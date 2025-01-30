import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_test1/model/goal_id.dart';

final selectedGoalIdProvider =
    StateNotifierProvider<SelectedGoalId, GoalId>((ref) => SelectedGoalId(ref));

class SelectedGoalId extends StateNotifier<GoalId> {
  // ignore: prefer_typing_uninitialized_variables
  final ref;

  SelectedGoalId(this.ref) : super(const GoalId());

  setGoalId(String goalId) {
    state = state.copyWith(id: goalId);
  }

  /// 新規目標追加
  /// ここで行うのは、Firestore に書き込む Goal オブジェクトに必要な title をセットする処理のみ
  setGoalTitle(String title) {
    state = state.copyWith(title: title);
  }
}
