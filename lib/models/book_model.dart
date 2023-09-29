import 'package:book_story/enums/category_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

@unfreezed
class Book with _$Book{
  factory Book({
    required int bookId,
    required String title,
    required String drawer,
    required String writer,
    required int bookPage,
    required CategoryType categoryAge,
    required List<CategoryType> categoryType,
    required int playTime,
    required String imagePath,
    required String bookDescriptionPath,
    required String writerDescriptionPath,
    required String publisherDescriptionPath,
    DateTime? creationTime,
    @Default(0)int playCount,
    @Default(0)int favoriteCount,
    // @Default(0.0)double rate,
}) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) =>
      _$BookFromJson(json);
}
