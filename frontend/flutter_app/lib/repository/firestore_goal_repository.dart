import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_test1/model/firestore_models.dart';

class FirestoreGoalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestoreのコレクション参照を簡潔に取得するヘルパーメソッド
  CollectionReference<Map<String, dynamic>> _userGoalsCollection(
      String userId) {
    return _firestore.collection('users').doc(userId).collection('goals');
  }

  /// Goalを追加するメソッド
  // Future<void> addGoal(String userId, Goal goal) async {
  //   try {
  //     // goal を firestore に登録
  //     // docRefには firestore に登録されたドキュメントの参照が入る
  //     final docRef = await _userGoalsCollection(userId).add(goal.toJson());
  //     //Firestoreに保存されたgoalのidをセットして返す
  //     final addedGoal = goal.copyWith(id: docRef.id);
  //     await _userGoalsCollection(userId)
  //         .doc(addedGoal.id)
  //         .set(addedGoal.toJson());
  //   } catch (e) {
  //     rethrow; // エラーを上位に伝播
  //   }
  // }

  Future<DocumentReference<Map<String, dynamic>>> addGoal(
      String userId, Goal goal) async {
    try {
      final docRef = await _userGoalsCollection(userId).add(goal.toJson());
      return docRef;
    } catch (e) {
      rethrow;
    }
  }

  /// Goalを取得するメソッド
  Future<List<Goal>> fetchGoals(String userId) async {
    try {
      final snapshot = await _userGoalsCollection(userId).get();
      return snapshot.docs.map((doc) => Goal.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Firestore読み込みエラー: $e');
      return [];
    }
  }

  /// Goalを更新するメソッド
  Future<void> updateGoal(String userId, Goal updatedGoal) async {
    try {
      await _userGoalsCollection(userId).doc().update(updatedGoal.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Goalを削除するメソッド
  Future<void> deleteGoal(String userId, String goalId) async {
    try {
      await _userGoalsCollection(userId).doc(goalId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // 目標の Stream を取得
  Stream<QuerySnapshot<Object?>> fetchGoalStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
