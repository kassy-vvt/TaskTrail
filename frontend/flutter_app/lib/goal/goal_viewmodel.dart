// goal_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_test1/model/firestore_models.dart';
import 'package:hackathon_test1/model/goal_id.dart';
import 'package:hackathon_test1/repository/firestore_goal_repository.dart';
import 'package:hackathon_test1/utils/auth_utils.dart';

// goalRepositoryProvider をクラス外で定義し、
// GoalNotifier のコンストラクタで ref.read(goalRepositoryProvider) を使用して
// FirestoreGoalRepository のインスタンスを取得することで、
// GoalNotifier は FirestoreGoalRepository の具体的な実装に依存しなくなる。
// これにより、モックを使ったテストが容易になり、より柔軟な設計になる。
final goalRepositoryProvider =
    Provider<FirestoreGoalRepository>((ref) => FirestoreGoalRepository());

class GoalViewModel extends StateNotifier<GoalId> {
  final Ref ref;
  final FirestoreGoalRepository _repository;

  GoalViewModel(this.ref)
      : _repository = ref.read(goalRepositoryProvider),
        super(const GoalId());

  /// 新規目標作成
  /// ここで行うのは、Firestore に Goal を追加する処理のみ
  /// 新規目標追加ではない
  Future<void> addGoal() async {
    final currentUser = getCurrentUser();
    if (currentUser == null) return;

    /// 追加する Goal オブジェクトの作成
    /// [setGoalTitle] でセットした title を使って Goal オブジェクトを作成
    final goal = Goal(
      title: state.title!,
      createdAt: DateTime.now(),
      // TODO : @kassy-vvt ここに view から受け取った limit と timePerWeek をセットする処理を追加してください
      // limit: ,
      // timePerWeek: ,
    );

    try {
      final docRef = await _repository.addGoal(currentUser.uid, goal);
      // 最新の goalId を取得する
      state = state.copyWith(id: docRef.id);
    } catch (e) {
      throw ('目標追加エラー: $e');
      // SnackbarHelper.show(context, '目標追加エラー: $e');
    }
  }

  // Future<void> _fetchGoals(BuildContext context) async {
  //   final currentUser = getCurrentUser(context);
  //   if (currentUser == null) return;
  //   state = await _repository.fetchGoals(currentUser.uid);
  // }
}

final goalViewModelProvider =
    StateNotifierProvider<GoalViewModel, GoalId>((ref) => GoalViewModel(ref));
