// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Book _$$_BookFromJson(Map<String, dynamic> json) => _$_Book(
      id: json['id'] as int,
      title: json['title'] as String,
      drawer: json['drawer'] as String,
      writer: json['writer'] as String,
      bookPage: json['bookPage'] as int,
      categoryAge: $enumDecode(_$CategoryTypeEnumMap, json['categoryAge']),
      categoryType: (json['categoryType'] as List<dynamic>)
          .map((e) => $enumDecode(_$CategoryTypeEnumMap, e))
          .toList(),
      playTime: json['playTime'] as int,
      imagePath: json['imagePath'] as String,
      description: json['description'] as String,
      creationTime: DateTime.parse(json['creationTime'] as String),
      playCount: json['playCount'] as int? ?? 0,
      favorite: json['favorite'] as int? ?? 0,
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$_BookToJson(_$_Book instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'drawer': instance.drawer,
      'writer': instance.writer,
      'bookPage': instance.bookPage,
      'categoryAge': _$CategoryTypeEnumMap[instance.categoryAge]!,
      'categoryType':
          instance.categoryType.map((e) => _$CategoryTypeEnumMap[e]!).toList(),
      'playTime': instance.playTime,
      'imagePath': instance.imagePath,
      'description': instance.description,
      'creationTime': instance.creationTime.toIso8601String(),
      'playCount': instance.playCount,
      'favorite': instance.favorite,
      'rate': instance.rate,
    };

const _$CategoryTypeEnumMap = {
  CategoryType.AGE_4_PLUS: 'AGE_4_PLUS',
  CategoryType.AGE_6_PLUS: 'AGE_6_PLUS',
  CategoryType.AGE_8_PLUS: 'AGE_8_PLUS',
  CategoryType.UPTO_4_AGE: 'UPTO_4_AGE',
  CategoryType.UPTO_6_AGE: 'UPTO_6_AGE',
  CategoryType.FAIRY_TALE: 'FAIRY_TALE',
  CategoryType.CREATIVE: 'CREATIVE',
  CategoryType.LIFE_STYLE: 'LIFE_STYLE',
  CategoryType.HABITS: 'HABITS',
  CategoryType.LEARNING: 'LEARNING',
  CategoryType.SOPHISTICATION: 'SOPHISTICATION',
  CategoryType.CULTURE: 'CULTURE',
  CategoryType.ART: 'ART',
  CategoryType.SOCIETY: 'SOCIETY',
  CategoryType.HISTORY: 'HISTORY',
  CategoryType.NATURAL: 'NATURAL',
  CategoryType.SCIENCE: 'SCIENCE',
  CategoryType.NONE: 'NONE',
};
