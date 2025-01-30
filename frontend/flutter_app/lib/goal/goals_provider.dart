import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_test1/goal/firestore_goal_repository.dart';
import 'package:hackathon_test1/model/firestore_models.dart';
import 'package:hackathon_test1/user/user_provider.dart';

final goalsProvider = StreamProvider<List<Goal>>((ref) {
  final user = ref.watch(userProvider).value;

  if (user == null) {
    return const Stream.empty(); // ログインしていない場合は空のストリームを返す
  }

  final goalRepository = ref.watch(firestoreGoalRepositoryProvider);
  return goalRepository.fetchGoalsStream(user.uid).map((snapshot) => snapshot
      .docs
      .map((doc) => Goal.fromFirestore(
          doc.data() as DocumentSnapshot<Map<String, dynamic>>))
      .toList());
});
