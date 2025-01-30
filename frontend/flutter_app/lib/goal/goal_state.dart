// goal_state.dart (状態クラス)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_test1/model/goal_id.dart';

enum GoalScreenState {
  noGoals, // 目標が 0 個
  goalNotCreated, // 目標は存在するが作成されていない
  goalSelected, // 目標選択済み
}

class GoalScreenStateNotifier extends StateNotifier<GoalScreenState> {
  GoalScreenStateNotifier() : super(GoalScreenState.noGoals);

  void updateState(List<GoalId> goals, String? selectedGoalId) {
    if (goals.isEmpty) {
      state = GoalScreenState.noGoals;
    } else if (selectedGoalId == null) {
      state = GoalScreenState.goalNotCreated;
    } else {
      state = GoalScreenState.goalSelected;
    }
  }
}

final goalScreenStateProvider =
    StateNotifierProvider<GoalScreenStateNotifier, GoalScreenState>(
  (ref) => GoalScreenStateNotifier(),
);
