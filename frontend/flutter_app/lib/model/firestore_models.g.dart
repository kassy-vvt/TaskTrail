// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      email: json['email'] as String? ?? '',
      goals: (json['goals'] as List<dynamic>?)
              ?.map((e) => Goal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'goals': instance.goals,
    };

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      timePerWeek: (json['timePerWeek'] as num?)?.toInt() ?? 0,
      limit: json['limit'] == null
          ? null
          : DateTime.parse(json['limit'] as String),
      chat: json['chat'] == null
          ? const []
          : const ChatConverter().fromJson(json['chat'] as List),
      tasks: json['tasks'] == null
          ? const []
          : const TaskConverter().fromJson(json['tasks'] as List),
    );

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
      'timePerWeek': instance.timePerWeek,
      'limit': instance.limit?.toIso8601String(),
      'chat': const ChatConverter().toJson(instance.chat),
      'tasks': const TaskConverter().toJson(instance.tasks),
    };

_$ChatImpl _$$ChatImplFromJson(Map<String, dynamic> json) => _$ChatImpl(
      id: json['id'] as String?,
      content: json['content'] as String,
      role: json['role'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      loading: json['loading'] as bool? ?? false,
      status: json['status'] as String? ?? 'success',
    );

Map<String, dynamic> _$$ChatImplToJson(_$ChatImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'role': instance.role,
      'createdAt': instance.createdAt?.toIso8601String(),
      'loading': instance.loading,
      'status': instance.status,
    };

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: (json['priority'] as num).toInt(),
      requiredTime: (json['requiredTime'] as num).toInt(),
      deadline: DateTime.parse(json['deadline'] as String),
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'priority': instance.priority,
      'requiredTime': instance.requiredTime,
      'deadline': instance.deadline.toIso8601String(),
    };
