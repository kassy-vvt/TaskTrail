// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      content: json['content'] as String,
      role: json['role'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      loading: json['loading'] as bool? ?? false,
      ragFileIds: (json['ragFileIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: json['status'] as String? ?? 'success',
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'role': instance.role,
      'createdAt': instance.createdAt?.toIso8601String(),
      'loading': instance.loading,
      'ragFileIds': instance.ragFileIds,
      'status': instance.status,
    };
