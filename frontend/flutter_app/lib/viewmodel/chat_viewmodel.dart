// lib/viewmodel/chat_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_test1/model/firestore_models.dart';
import 'package:hackathon_test1/repository/firestore_chat_repository.dart';

final chatViewModelProvider =
    StateNotifierProvider<ChatViewModel, List<Chat>>((ref) => ChatViewModel());

class ChatViewModel extends StateNotifier<List<Chat>> {
  final ChatRepository _chatRepository = ChatRepository();
  final TextEditingController textController = TextEditingController();
  String? selectedGoalId;

  ChatViewModel() : super([]);

  // メッセージを Firestore に追加
  // Future<void> addMessage(String goalId, BuildContext context) async {
  //   final currentUser = getCurrentUser(context);
  //   if (currentUser == null) return;
  //   if (!context.mounted) return;

  //   final text = textController.text.trim();
  //   if (text.isEmpty) return;

  //   try {
  //     // 本来、UIに通知するならここでstateを更新する
  //     // しかし、今回は firestore を監視し、Firestore の変更を検知して UI を更新するため
  //     // ここで state を更新する必要はない
  //     await _chatRepository.addMessage(currentUser.uid, goalId, text);
  //     textController.clear();
  //     SnackbarHelper.show(context, 'メッセージが送信されました');
  //   } catch (e) {
  //     SnackbarHelper.show(context, 'Firestore 書き込みエラー: $e');
  //   }
  // }

  // // チャットメッセージの Stream を取得
  // Stream<QuerySnapshot<Object?>>? getChatStream(String userId, String? goalId) {
  //   if (goalId == null) return const Stream.empty();
  //   return _chatRepository.getChatStream(userId, goalId);
  // }

  // // 目標の Stream を取得
  // Stream<QuerySnapshot<Object?>>? getGoalStream(String userId) {
  //   return _chatRepository.getGoalStream(userId);
  // }
}
