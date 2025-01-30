// lib/repository/chat_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_test1/model/firestore_models.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // メッセージを Firestore に追加
  Future<void> addMessage(String userId, String goalId, String text) async {
    final goalId =
        _firestore.collection('users').doc(userId).collection('goals').doc().id;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .collection('chat')
        .add(Chat(
          content: text,
          role: "user",
          createdAt: DateTime.now(),
        ).toJson());
  }

  // チャットメッセージの Stream を取得
  Stream<QuerySnapshot<Object?>> getChatStream(String userId, String goalId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
