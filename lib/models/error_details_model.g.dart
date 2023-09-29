// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ErrorDetailsImpl _$$ErrorDetailsImplFromJson(Map<String, dynamic> json) =>
    _$ErrorDetailsImpl(
      errorCode: json['errorCode'] as int,
      errorMessage: json['errorMessage'] as String,
      devErrorMessage: json['devErrorMessage'] as String,
      timestamp: json['timestamp'] as int,
    );

Map<String, dynamic> _$$ErrorDetailsImplToJson(_$ErrorDetailsImpl instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
      'devErrorMessage': instance.devErrorMessage,
      'timestamp': instance.timestamp,
    };
