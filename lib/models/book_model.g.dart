// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Book _$$_BookFromJson(Map<String, dynamic> json) => _$_Book(
      bookId: json['bookId'] as int,
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
      creationTime: json['creationTime'] == null
          ? null
          : DateTime.parse(json['creationTime'] as String),
      playCount: json['playCount'] as int? ?? 0,
      favoriteCount: json['favoriteCount'] as int? ?? 0,
    );

Map<String, dynamic> _$$_BookToJson(_$_Book instance) => <String, dynamic>{
      'bookId': instance.bookId,
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
      'creationTime': instance.creationTime?.toIso8601String(),
      'playCount': instance.playCount,
      'favoriteCount': instance.favoriteCount,
    };

const _$CategoryTypeEnumMap = {
  CategoryType.age4plus: 'age4plus',
  CategoryType.age6plus: 'age6plus',
  CategoryType.age8plus: 'age8plus',
  CategoryType.upto4age: 'upto4age',
  CategoryType.upto6age: 'upto6age',
  CategoryType.fairyTale: 'fairyTale',
  CategoryType.creative: 'creative',
  CategoryType.lifeStyle: 'lifeStyle',
  CategoryType.habits: 'habits',
  CategoryType.learning: 'learning',
  CategoryType.sophistication: 'sophistication',
  CategoryType.culture: 'culture',
  CategoryType.society: 'society',
  CategoryType.natural: 'natural',
  CategoryType.science: 'science',
  CategoryType.masterpiece: 'masterpiece',
  CategoryType.classic: 'classic',
  CategoryType.none: 'none',
};
