// lib/view/chat_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_test1/goal/add_goal_button.dart';
import 'package:hackathon_test1/goal/goal_state.dart';
import 'package:hackathon_test1/goal/goal_viewmodel.dart';
import 'package:hackathon_test1/goal/goals_provider.dart';
import 'package:hackathon_test1/goal/selected_goal_id_provider.dart';
import 'package:hackathon_test1/model/firestore_models.dart';
import 'package:hackathon_test1/viewmodel/chat_viewmodel.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalScreenState = ref.watch(goalScreenStateProvider);
    final goals = ref.watch(goalsProvider); // 目標リスト
    final selectedGoalId = ref.watch(selectedGoalIdProvider); // 選択された目標 ID
    final viewModel = ref.watch(chatViewModelProvider);
    final goalId = ref.watch(goalViewModelProvider).id;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('ログインしていません')),
      );
    }

    // final chatStream =
    //     viewModel.getChatStream(user.uid, viewModel.selectedGoalId);
    // final goalStream = viewModel.getGoalStream(user.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 150,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '目標一覧',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: AddGoalButton(),
                      ),
                    ],
                  ),
                ),
              ),
              // TODO : GoalId オブジェクトを参照すればよい。StreamBuilder は不要
              StreamBuilder<List<Goal>>(
                stream: goals.when(
                  data: (data) => Stream.value(data), // Stream<List<Goal>> を返す
                  error: (error, stackTrace) =>
                      const Stream.empty(), // エラー時は空の Stream を返す
                  loading: () => const Stream.empty(), // ローディング時は空の Stream を返す
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final goals = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index]; // Goal オブジェクトを直接取得
                      // TODO : あとで考える
                      // final goalId = goals.; // goal.id は Firestore から取得した ID
                      return ListTile(
                        title: Text(goal.title),
                        onTap: () {
                          // TODO : あとで考える
                          // ref
                          //     .read(selectedGoalIdProvider.notifier)
                          //     .setGoalId(goalId);
                          Navigator.pop(context); // drawerを閉じる
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          switch (goalScreenState) {
            case GoalScreenState.noGoals:
              return const Center(child: AddGoalButton());
            case GoalScreenState.goalNotCreated:
              // @kassy-vvt ここに目標が選択されていない場合に表示するウィジェットを追加してください
              // 期日・週あたりの時間設定 ウィジェットを追加してください
              return const Center(child: Text('目標を選択してください'));
            case GoalScreenState.goalSelected:
              return const Center(child: Text('チャット画面表示(ダミー)'));
            // return StreamBuilder<QuerySnapshot>(
            // ... (チャット画面のコード)
            // );
          }
        },
      ),
      // body: Column(
      //   children: [
      //     // メッセージ一覧
      //     Expanded(
      //       child: goalId != null
      //           ? StreamBuilder<QuerySnapshot>(
      //               stream: chatStream,
      //               builder: (context, snapshot) {
      //                 if (!snapshot.hasData) {
      //                   return const Center(child: CircularProgressIndicator());
      //                 }
      //                 final docs = snapshot.data!.docs;
      //                 return ListView.builder(
      //                   reverse: true,
      //                   itemCount: docs.length,
      //                   itemBuilder: (context, index) {
      //                     final chat = viewModel.getChatData(docs[index]);

      //                     return ListTile(
      //                       title: Text(chat.content),
      //                       subtitle: Text('${chat.role} - ${chat.createdAt}'),
      //                     );
      //                   },
      //                 );
      //               },
      //             )
      //           : const Center(
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Text('目標を選択してください'),
      //                   // TODO : chatStream が 存在する場合はドロワーを開くボタンを追加する
      //                   AddGoalButton(),
      //                 ],
      //               ),
      //             ),
      //     ),
      //     // 入力欄
      //     goalId != null
      //         ? Padding(
      //             padding: const EdgeInsets.only(
      //                 right: 16.0, left: 16.0, bottom: 32.0),
      //             child: Row(
      //               children: [
      //                 Expanded(
      //                   child: Container(
      //                     height: 60, // 高さを広く設定
      //                     decoration: BoxDecoration(
      //                       color: Colors.white,
      //                       borderRadius: BorderRadius.circular(12), // 角を丸くする
      //                       border: Border.all(color: Colors.grey), // 枠線を追加
      //                     ),
      //                     child: TextField(
      //                       controller: viewModel.textController,
      //                       decoration: const InputDecoration(
      //                         hintText: 'Enter message',
      //                         border: InputBorder.none, // デフォルトの枠線を削除
      //                         contentPadding: EdgeInsets.symmetric(
      //                             horizontal: 16, vertical: 16), // 内側の余白を設定
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 IconButton(
      //                   icon: const Icon(
      //                     Icons.send,
      //                     color: Colors.blueAccent,
      //                   ),
      //                   onPressed: () {
      //                     ref
      //                         .read(chatViewModelProvider.notifier)
      //                         .addMessage(goalId, context);
      //                   },
      //                 ),
      //               ],
      //             ),
      //           )
      //         : const SizedBox(),
      //   ],
      // ),
    );
  }
}
