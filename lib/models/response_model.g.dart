// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ResponseModel _$$_ResponseModelFromJson(Map<String, dynamic> json) =>
    _$_ResponseModel(
      responseStatus: $enumDecodeNullable(
              _$ResponseStatusEnumMap, json['responseStatus']) ??
          ResponseStatus.saved,
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String? ?? 'Saved',
      object: json['object'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$_ResponseModelToJson(_$_ResponseModel instance) =>
    <String, dynamic>{
      'responseStatus': _$ResponseStatusEnumMap[instance.responseStatus]!,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'object': instance.object,
    };

const _$ResponseStatusEnumMap = {
  ResponseStatus.saved: 'saved',
  ResponseStatus.failed: 'failed',
  ResponseStatus.unauthorized: 'unauthorized',
  ResponseStatus.authorized: 'authorized',
  ResponseStatus.expired: 'expired',
  ResponseStatus.none: 'none',
};
