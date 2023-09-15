// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Book _$BookFromJson(Map<String, dynamic> json) {
  return _Book.fromJson(json);
}

/// @nodoc
mixin _$Book {
  int get bookId => throw _privateConstructorUsedError;
  set bookId(int value) => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  set title(String value) => throw _privateConstructorUsedError;
  String get drawer => throw _privateConstructorUsedError;
  set drawer(String value) => throw _privateConstructorUsedError;
  String get writer => throw _privateConstructorUsedError;
  set writer(String value) => throw _privateConstructorUsedError;
  int get bookPage => throw _privateConstructorUsedError;
  set bookPage(int value) => throw _privateConstructorUsedError;
  CategoryType get categoryAge => throw _privateConstructorUsedError;
  set categoryAge(CategoryType value) => throw _privateConstructorUsedError;
  List<CategoryType> get categoryType => throw _privateConstructorUsedError;
  set categoryType(List<CategoryType> value) =>
      throw _privateConstructorUsedError;
  int get playTime => throw _privateConstructorUsedError;
  set playTime(int value) => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  set imagePath(String value) => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  set description(String value) => throw _privateConstructorUsedError;
  DateTime? get creationTime => throw _privateConstructorUsedError;
  set creationTime(DateTime? value) => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  set playCount(int value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookCopyWith<Book> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookCopyWith<$Res> {
  factory $BookCopyWith(Book value, $Res Function(Book) then) =
      _$BookCopyWithImpl<$Res, Book>;
  @useResult
  $Res call(
      {int bookId,
      String title,
      String drawer,
      String writer,
      int bookPage,
      CategoryType categoryAge,
      List<CategoryType> categoryType,
      int playTime,
      String imagePath,
      String description,
      DateTime? creationTime,
      int playCount});
}

/// @nodoc
class _$BookCopyWithImpl<$Res, $Val extends Book>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
    Object? title = null,
    Object? drawer = null,
    Object? writer = null,
    Object? bookPage = null,
    Object? categoryAge = null,
    Object? categoryType = null,
    Object? playTime = null,
    Object? imagePath = null,
    Object? description = null,
    Object? creationTime = freezed,
    Object? playCount = null,
  }) {
    return _then(_value.copyWith(
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      drawer: null == drawer
          ? _value.drawer
          : drawer // ignore: cast_nullable_to_non_nullable
              as String,
      writer: null == writer
          ? _value.writer
          : writer // ignore: cast_nullable_to_non_nullable
              as String,
      bookPage: null == bookPage
          ? _value.bookPage
          : bookPage // ignore: cast_nullable_to_non_nullable
              as int,
      categoryAge: null == categoryAge
          ? _value.categoryAge
          : categoryAge // ignore: cast_nullable_to_non_nullable
              as CategoryType,
      categoryType: null == categoryType
          ? _value.categoryType
          : categoryType // ignore: cast_nullable_to_non_nullable
              as List<CategoryType>,
      playTime: null == playTime
          ? _value.playTime
          : playTime // ignore: cast_nullable_to_non_nullable
              as int,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      creationTime: freezed == creationTime
          ? _value.creationTime
          : creationTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      playCount: null == playCount
          ? _value.playCount
          : playCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$$_BookCopyWith(_$_Book value, $Res Function(_$_Book) then) =
      __$$_BookCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int bookId,
      String title,
      String drawer,
      String writer,
      int bookPage,
      CategoryType categoryAge,
      List<CategoryType> categoryType,
      int playTime,
      String imagePath,
      String description,
      DateTime? creationTime,
      int playCount});
}

/// @nodoc
class __$$_BookCopyWithImpl<$Res> extends _$BookCopyWithImpl<$Res, _$_Book>
    implements _$$_BookCopyWith<$Res> {
  __$$_BookCopyWithImpl(_$_Book _value, $Res Function(_$_Book) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
    Object? title = null,
    Object? drawer = null,
    Object? writer = null,
    Object? bookPage = null,
    Object? categoryAge = null,
    Object? categoryType = null,
    Object? playTime = null,
    Object? imagePath = null,
    Object? description = null,
    Object? creationTime = freezed,
    Object? playCount = null,
  }) {
    return _then(_$_Book(
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      drawer: null == drawer
          ? _value.drawer
          : drawer // ignore: cast_nullable_to_non_nullable
              as String,
      writer: null == writer
          ? _value.writer
          : writer // ignore: cast_nullable_to_non_nullable
              as String,
      bookPage: null == bookPage
          ? _value.bookPage
          : bookPage // ignore: cast_nullable_to_non_nullable
              as int,
      categoryAge: null == categoryAge
          ? _value.categoryAge
          : categoryAge // ignore: cast_nullable_to_non_nullable
              as CategoryType,
      categoryType: null == categoryType
          ? _value.categoryType
          : categoryType // ignore: cast_nullable_to_non_nullable
              as List<CategoryType>,
      playTime: null == playTime
          ? _value.playTime
          : playTime // ignore: cast_nullable_to_non_nullable
              as int,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      creationTime: freezed == creationTime
          ? _value.creationTime
          : creationTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      playCount: null == playCount
          ? _value.playCount
          : playCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Book implements _Book {
  _$_Book(
      {required this.bookId,
      required this.title,
      required this.drawer,
      required this.writer,
      required this.bookPage,
      required this.categoryAge,
      required this.categoryType,
      required this.playTime,
      required this.imagePath,
      required this.description,
      this.creationTime,
      this.playCount = 0});

  factory _$_Book.fromJson(Map<String, dynamic> json) => _$$_BookFromJson(json);

  @override
  int bookId;
  @override
  String title;
  @override
  String drawer;
  @override
  String writer;
  @override
  int bookPage;
  @override
  CategoryType categoryAge;
  @override
  List<CategoryType> categoryType;
  @override
  int playTime;
  @override
  String imagePath;
  @override
  String description;
  @override
  DateTime? creationTime;
  @override
  @JsonKey()
  int playCount;

  @override
  String toString() {
    return 'Book(bookId: $bookId, title: $title, drawer: $drawer, writer: $writer, bookPage: $bookPage, categoryAge: $categoryAge, categoryType: $categoryType, playTime: $playTime, imagePath: $imagePath, description: $description, creationTime: $creationTime, playCount: $playCount)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BookCopyWith<_$_Book> get copyWith =>
      __$$_BookCopyWithImpl<_$_Book>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BookToJson(
      this,
    );
  }
}

abstract class _Book implements Book {
  factory _Book(
      {required int bookId,
      required String title,
      required String drawer,
      required String writer,
      required int bookPage,
      required CategoryType categoryAge,
      required List<CategoryType> categoryType,
      required int playTime,
      required String imagePath,
      required String description,
      DateTime? creationTime,
      int playCount}) = _$_Book;

  factory _Book.fromJson(Map<String, dynamic> json) = _$_Book.fromJson;

  @override
  int get bookId;
  set bookId(int value);
  @override
  String get title;
  set title(String value);
  @override
  String get drawer;
  set drawer(String value);
  @override
  String get writer;
  set writer(String value);
  @override
  int get bookPage;
  set bookPage(int value);
  @override
  CategoryType get categoryAge;
  set categoryAge(CategoryType value);
  @override
  List<CategoryType> get categoryType;
  set categoryType(List<CategoryType> value);
  @override
  int get playTime;
  set playTime(int value);
  @override
  String get imagePath;
  set imagePath(String value);
  @override
  String get description;
  set description(String value);
  @override
  DateTime? get creationTime;
  set creationTime(DateTime? value);
  @override
  int get playCount;
  set playCount(int value);
  @override
  @JsonKey(ignore: true)
  _$$_BookCopyWith<_$_Book> get copyWith => throw _privateConstructorUsedError;
}
