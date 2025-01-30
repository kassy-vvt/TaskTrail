// lib/model/chat_message.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_id.freezed.dart';

@freezed
class GoalId with _$GoalId {
  const factory GoalId({
    String? title,
    String? id,
  }) = _GoalId;
}
