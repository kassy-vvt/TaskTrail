import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_test1/view/common/snackbar_helper.dart';

class AddGoalButton extends ConsumerWidget {
  const AddGoalButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final TextEditingController goalController =
                TextEditingController();
            return AlertDialog(
              title: const Text('新規目標追加'),
              content: TextField(
                controller: goalController,
                decoration: const InputDecoration(
                  hintText: '目標を入力してください',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('キャンセル'),
                ),
                TextButton(
                  onPressed: () async {
                    final goalTitle = goalController.text.trim();
                    if (goalTitle.isNotEmpty) {
                      // ref
                      //     .read(goalViewModelProvider.notifier)
                      //     .setGoalTitle(goalTitle);
                      SnackbarHelper.show(context, '目標を追加しました');
                    } else {
                      SnackbarHelper.show(context, '目標が未入力です');
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('追加'),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('新規目標'),
    );
  }
}
