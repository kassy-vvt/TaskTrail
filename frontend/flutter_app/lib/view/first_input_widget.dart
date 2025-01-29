// lib/view/chat_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_test1/view/common/add_goal_button.dart';
import 'package:hackathon_test1/viewmodel/chat_viewmodel.dart';
import 'package:hackathon_test1/viewmodel/goal_viewmodel.dart';

class FirstInputWidget extends StatefulWidget {
  final ChatViewModel chatViewModel;
  final String userId;
  final String goalId;

  const FirstInputWidget({
    Key? key,
    required this.chatViewModel,
    required this.userId,
    required this.goalId,
  }) : super(key: key);

  @override
  State<FirstInputWidget> createState() => _FirstInputWidgetState();
}

class _FirstInputWidgetState extends State<FirstInputWidget> {
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _weeklyHoursController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 32.0, top: 8.0),
      // 下に寄せるために、上に大きな余白をとらないようにしています
      child: Column(
        mainAxisSize: MainAxisSize.min, // 必要最小限の高さに
        children: [
          // 期日 (カレンダーPicker)
          TextField(
            controller: _deadlineController,
            decoration: const InputDecoration(
              labelText: '期日を選択',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  _deadlineController.text =
                  "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
                });
              }
            },
          ),
          const SizedBox(height: 8),

          // 週あたり作業時間
          TextField(
            controller: _weeklyHoursController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '週あたり作業時間(時間)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),

          // メッセージ入力
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Enter message',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // 送信ボタン (右端にアイコンを寄せたければRowを使う)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.blueAccent,
                ),
                onPressed: () async {
                  // このボタンで「期日」「週あたり作業時間」「メッセージ」を一括でFirestoreへ保存
                  final deadlineText = _deadlineController.text.trim();
                  final weeklyHoursText = _weeklyHoursController.text.trim();
                  final messageText = _messageController.text.trim();

                  if (deadlineText.isEmpty ||
                      weeklyHoursText.isEmpty ||
                      messageText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('すべての項目を入力してください')),
                    );
                    return;
                  }

                  // DateTimeへの変換
                  try {
                    final parts = deadlineText.split('/');
                    final year = int.parse(parts[0]);
                    final month = int.parse(parts[1]);
                    final day = int.parse(parts[2]);
                    final deadlineDate = DateTime(year, month, day);

                    final weeklyHours = double.parse(weeklyHoursText);

                    // Firestore 登録処理（chatViewModel にまとめて実装）
                    await widget.chatViewModel.addGoalDataAndFirstMessage(
                      context: context,
                      userId: widget.userId,
                      goalId: widget.goalId,
                      deadline: deadlineDate,
                      weeklyHours: weeklyHours,
                      message: messageText,
                    );

                    // 入力欄をクリア
                    _deadlineController.clear();
                    _weeklyHoursController.clear();
                    _messageController.clear();

                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('入力値が不正です: $e')),
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
