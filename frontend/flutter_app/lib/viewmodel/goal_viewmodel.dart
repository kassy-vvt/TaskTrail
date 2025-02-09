import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_test1/view/common/snackbar_helper.dart';

final goalViewModelProvider = ChangeNotifierProvider((ref) => GoalViewModel());

class GoalViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addGoal(String goal, BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      SnackbarHelper.show(context, 'ログインしていません');
      return;
    }

    try {
      final goalId = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('goals')
          .doc()
          .id;
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('goals')
          .doc(goalId)
          .set({
        'goal': goal,
        'createdAt': FieldValue.serverTimestamp(),
      });
      notifyListeners();
      // ignore: use_build_context_synchronously
      SnackbarHelper.show(context, '目標が追加されました');
    } catch (e) {
      // ignore: use_build_context_synchronously
      SnackbarHelper.show(context, 'Firestore書き込みエラー: $e');
    }
  }
}
