// lib/model/chat_message.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_models.freezed.dart';
part 'firestore_models.g.dart';

@freezed
class User with _$User {
  const factory User({
    @Default('') @JsonKey(name: 'email') String email,
    @Default([]) @JsonKey(name: 'goals') List<Goal> goals,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }
    return User.fromJson(data);
  }
}

@freezed
class Goal with _$Goal {
  const factory Goal({
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @Default(0) @JsonKey(name: 'timePerWeek') int timePerWeek,
    @JsonKey(name: 'limit') DateTime? limit,
    @Default([]) @JsonKey(name: 'chat') @ChatConverter() List<Chat> chat,
    @Default([]) @JsonKey(name: 'tasks') @TaskConverter() List<Task> tasks,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  factory Goal.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }
    return Goal.fromJson(data);
  }
}

@freezed
class Chat with _$Chat {
  const factory Chat({
    String? id,
    @JsonKey(name: 'content') required String content,
    @JsonKey(name: 'role') required String role,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @Default(false) @JsonKey(name: 'loading') bool loading,
    @Default('success') @JsonKey(name: 'status') String status,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  factory Chat.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }
    return Chat.fromJson(data).copyWith(id: doc.id);
  }
}

// ChatクラスをJSONに変換・復元するためのコンバーター
class ChatConverter implements JsonConverter<List<Chat>, List<dynamic>> {
  const ChatConverter();

  @override
  List<Chat> fromJson(List<dynamic> json) =>
      json.map((e) => Chat.fromJson(e as Map<String, dynamic>)).toList();

  @override
  List<dynamic> toJson(List<Chat> object) =>
      object.map((e) => e.toJson()).toList();
}

@freezed
class Task with _$Task {
  const factory Task({
    String? id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'priority') required int priority,
    @JsonKey(name: 'requiredTime') required int requiredTime,
    @JsonKey(name: 'deadline') required DateTime deadline,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document data is null');
    }
    return Task.fromJson(data).copyWith(id: doc.id);
  }
}

// TaskクラスをJSONに変換・復元するためのコンバーター
class TaskConverter implements JsonConverter<List<Task>, List<dynamic>> {
  const TaskConverter();

  @override
  List<Task> fromJson(List<dynamic> json) =>
      json.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();

  @override
  List<dynamic> toJson(List<Task> object) =>
      object.map((e) => e.toJson()).toList();
}
