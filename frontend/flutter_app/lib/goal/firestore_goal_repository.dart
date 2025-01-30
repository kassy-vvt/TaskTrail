import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_test1/model/firestore_models.dart';

final firestoreGoalRepositoryProvider =
    Provider<FirestoreGoalRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  return FirestoreGoalRepository(firestore);
});

class FirestoreGoalRepository {
  final FirebaseFirestore _firestore;

  FirestoreGoalRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> _userGoalsCollection(
      String userId) {
    return _firestore.collection('users').doc(userId).collection('goals');
  }

  Future<DocumentReference<Map<String, dynamic>>> addGoal(
      String userId, Goal goal) async {
    try {
      return await _userGoalsCollection(userId).add(goal.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchGoalsStream(String userId) {
    return _userGoalsCollection(userId).snapshots();
  }

  Future<void> updateGoal(
      String userId, String goalId, Goal updatedGoal) async {
    try {
      await _userGoalsCollection(userId)
          .doc(goalId)
          .update(updatedGoal.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGoal(String userId, String goalId) async {
    try {
      await _userGoalsCollection(userId).doc(goalId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
