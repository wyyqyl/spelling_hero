// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dictation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DictationState {

 int get listId; List<DictationItem> get items; int get currentIndex; String get currentInput; FeedbackStatus get feedbackStatus; DictationMode get mode; List<DictationMistake> get mistakes; int get correctCount; int get shakeCount; bool get isFinished; bool get isLoading;
/// Create a copy of DictationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DictationStateCopyWith<DictationState> get copyWith => _$DictationStateCopyWithImpl<DictationState>(this as DictationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DictationState&&(identical(other.listId, listId) || other.listId == listId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.currentInput, currentInput) || other.currentInput == currentInput)&&(identical(other.feedbackStatus, feedbackStatus) || other.feedbackStatus == feedbackStatus)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.mistakes, mistakes)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.shakeCount, shakeCount) || other.shakeCount == shakeCount)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,listId,const DeepCollectionEquality().hash(items),currentIndex,currentInput,feedbackStatus,mode,const DeepCollectionEquality().hash(mistakes),correctCount,shakeCount,isFinished,isLoading);

@override
String toString() {
  return 'DictationState(listId: $listId, items: $items, currentIndex: $currentIndex, currentInput: $currentInput, feedbackStatus: $feedbackStatus, mode: $mode, mistakes: $mistakes, correctCount: $correctCount, shakeCount: $shakeCount, isFinished: $isFinished, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $DictationStateCopyWith<$Res>  {
  factory $DictationStateCopyWith(DictationState value, $Res Function(DictationState) _then) = _$DictationStateCopyWithImpl;
@useResult
$Res call({
 int listId, List<DictationItem> items, int currentIndex, String currentInput, FeedbackStatus feedbackStatus, DictationMode mode, List<DictationMistake> mistakes, int correctCount, int shakeCount, bool isFinished, bool isLoading
});




}
/// @nodoc
class _$DictationStateCopyWithImpl<$Res>
    implements $DictationStateCopyWith<$Res> {
  _$DictationStateCopyWithImpl(this._self, this._then);

  final DictationState _self;
  final $Res Function(DictationState) _then;

/// Create a copy of DictationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? listId = null,Object? items = null,Object? currentIndex = null,Object? currentInput = null,Object? feedbackStatus = null,Object? mode = null,Object? mistakes = null,Object? correctCount = null,Object? shakeCount = null,Object? isFinished = null,Object? isLoading = null,}) {
  return _then(_self.copyWith(
listId: null == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DictationItem>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,currentInput: null == currentInput ? _self.currentInput : currentInput // ignore: cast_nullable_to_non_nullable
as String,feedbackStatus: null == feedbackStatus ? _self.feedbackStatus : feedbackStatus // ignore: cast_nullable_to_non_nullable
as FeedbackStatus,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as DictationMode,mistakes: null == mistakes ? _self.mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as List<DictationMistake>,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,shakeCount: null == shakeCount ? _self.shakeCount : shakeCount // ignore: cast_nullable_to_non_nullable
as int,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DictationState].
extension DictationStatePatterns on DictationState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DictationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DictationState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DictationState value)  $default,){
final _that = this;
switch (_that) {
case _DictationState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DictationState value)?  $default,){
final _that = this;
switch (_that) {
case _DictationState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int listId,  List<DictationItem> items,  int currentIndex,  String currentInput,  FeedbackStatus feedbackStatus,  DictationMode mode,  List<DictationMistake> mistakes,  int correctCount,  int shakeCount,  bool isFinished,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DictationState() when $default != null:
return $default(_that.listId,_that.items,_that.currentIndex,_that.currentInput,_that.feedbackStatus,_that.mode,_that.mistakes,_that.correctCount,_that.shakeCount,_that.isFinished,_that.isLoading);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int listId,  List<DictationItem> items,  int currentIndex,  String currentInput,  FeedbackStatus feedbackStatus,  DictationMode mode,  List<DictationMistake> mistakes,  int correctCount,  int shakeCount,  bool isFinished,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _DictationState():
return $default(_that.listId,_that.items,_that.currentIndex,_that.currentInput,_that.feedbackStatus,_that.mode,_that.mistakes,_that.correctCount,_that.shakeCount,_that.isFinished,_that.isLoading);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int listId,  List<DictationItem> items,  int currentIndex,  String currentInput,  FeedbackStatus feedbackStatus,  DictationMode mode,  List<DictationMistake> mistakes,  int correctCount,  int shakeCount,  bool isFinished,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _DictationState() when $default != null:
return $default(_that.listId,_that.items,_that.currentIndex,_that.currentInput,_that.feedbackStatus,_that.mode,_that.mistakes,_that.correctCount,_that.shakeCount,_that.isFinished,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _DictationState implements DictationState {
  const _DictationState({required this.listId, required final  List<DictationItem> items, this.currentIndex = 0, this.currentInput = '', this.feedbackStatus = FeedbackStatus.none, this.mode = DictationMode.practice, final  List<DictationMistake> mistakes = const [], this.correctCount = 0, this.shakeCount = 0, this.isFinished = false, this.isLoading = false}): _items = items,_mistakes = mistakes;
  

@override final  int listId;
 final  List<DictationItem> _items;
@override List<DictationItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int currentIndex;
@override@JsonKey() final  String currentInput;
@override@JsonKey() final  FeedbackStatus feedbackStatus;
@override@JsonKey() final  DictationMode mode;
 final  List<DictationMistake> _mistakes;
@override@JsonKey() List<DictationMistake> get mistakes {
  if (_mistakes is EqualUnmodifiableListView) return _mistakes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mistakes);
}

@override@JsonKey() final  int correctCount;
@override@JsonKey() final  int shakeCount;
@override@JsonKey() final  bool isFinished;
@override@JsonKey() final  bool isLoading;

/// Create a copy of DictationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DictationStateCopyWith<_DictationState> get copyWith => __$DictationStateCopyWithImpl<_DictationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DictationState&&(identical(other.listId, listId) || other.listId == listId)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.currentInput, currentInput) || other.currentInput == currentInput)&&(identical(other.feedbackStatus, feedbackStatus) || other.feedbackStatus == feedbackStatus)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other._mistakes, _mistakes)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.shakeCount, shakeCount) || other.shakeCount == shakeCount)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,listId,const DeepCollectionEquality().hash(_items),currentIndex,currentInput,feedbackStatus,mode,const DeepCollectionEquality().hash(_mistakes),correctCount,shakeCount,isFinished,isLoading);

@override
String toString() {
  return 'DictationState(listId: $listId, items: $items, currentIndex: $currentIndex, currentInput: $currentInput, feedbackStatus: $feedbackStatus, mode: $mode, mistakes: $mistakes, correctCount: $correctCount, shakeCount: $shakeCount, isFinished: $isFinished, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$DictationStateCopyWith<$Res> implements $DictationStateCopyWith<$Res> {
  factory _$DictationStateCopyWith(_DictationState value, $Res Function(_DictationState) _then) = __$DictationStateCopyWithImpl;
@override @useResult
$Res call({
 int listId, List<DictationItem> items, int currentIndex, String currentInput, FeedbackStatus feedbackStatus, DictationMode mode, List<DictationMistake> mistakes, int correctCount, int shakeCount, bool isFinished, bool isLoading
});




}
/// @nodoc
class __$DictationStateCopyWithImpl<$Res>
    implements _$DictationStateCopyWith<$Res> {
  __$DictationStateCopyWithImpl(this._self, this._then);

  final _DictationState _self;
  final $Res Function(_DictationState) _then;

/// Create a copy of DictationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? listId = null,Object? items = null,Object? currentIndex = null,Object? currentInput = null,Object? feedbackStatus = null,Object? mode = null,Object? mistakes = null,Object? correctCount = null,Object? shakeCount = null,Object? isFinished = null,Object? isLoading = null,}) {
  return _then(_DictationState(
listId: null == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DictationItem>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,currentInput: null == currentInput ? _self.currentInput : currentInput // ignore: cast_nullable_to_non_nullable
as String,feedbackStatus: null == feedbackStatus ? _self.feedbackStatus : feedbackStatus // ignore: cast_nullable_to_non_nullable
as FeedbackStatus,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as DictationMode,mistakes: null == mistakes ? _self._mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as List<DictationMistake>,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,shakeCount: null == shakeCount ? _self.shakeCount : shakeCount // ignore: cast_nullable_to_non_nullable
as int,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$DictationMistake {

 String get correctSpelling; String get userInput;
/// Create a copy of DictationMistake
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DictationMistakeCopyWith<DictationMistake> get copyWith => _$DictationMistakeCopyWithImpl<DictationMistake>(this as DictationMistake, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DictationMistake&&(identical(other.correctSpelling, correctSpelling) || other.correctSpelling == correctSpelling)&&(identical(other.userInput, userInput) || other.userInput == userInput));
}


@override
int get hashCode => Object.hash(runtimeType,correctSpelling,userInput);

@override
String toString() {
  return 'DictationMistake(correctSpelling: $correctSpelling, userInput: $userInput)';
}


}

/// @nodoc
abstract mixin class $DictationMistakeCopyWith<$Res>  {
  factory $DictationMistakeCopyWith(DictationMistake value, $Res Function(DictationMistake) _then) = _$DictationMistakeCopyWithImpl;
@useResult
$Res call({
 String correctSpelling, String userInput
});




}
/// @nodoc
class _$DictationMistakeCopyWithImpl<$Res>
    implements $DictationMistakeCopyWith<$Res> {
  _$DictationMistakeCopyWithImpl(this._self, this._then);

  final DictationMistake _self;
  final $Res Function(DictationMistake) _then;

/// Create a copy of DictationMistake
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? correctSpelling = null,Object? userInput = null,}) {
  return _then(_self.copyWith(
correctSpelling: null == correctSpelling ? _self.correctSpelling : correctSpelling // ignore: cast_nullable_to_non_nullable
as String,userInput: null == userInput ? _self.userInput : userInput // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DictationMistake].
extension DictationMistakePatterns on DictationMistake {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DictationMistake value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DictationMistake() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DictationMistake value)  $default,){
final _that = this;
switch (_that) {
case _DictationMistake():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DictationMistake value)?  $default,){
final _that = this;
switch (_that) {
case _DictationMistake() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String correctSpelling,  String userInput)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DictationMistake() when $default != null:
return $default(_that.correctSpelling,_that.userInput);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String correctSpelling,  String userInput)  $default,) {final _that = this;
switch (_that) {
case _DictationMistake():
return $default(_that.correctSpelling,_that.userInput);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String correctSpelling,  String userInput)?  $default,) {final _that = this;
switch (_that) {
case _DictationMistake() when $default != null:
return $default(_that.correctSpelling,_that.userInput);case _:
  return null;

}
}

}

/// @nodoc


class _DictationMistake implements DictationMistake {
  const _DictationMistake({required this.correctSpelling, required this.userInput});
  

@override final  String correctSpelling;
@override final  String userInput;

/// Create a copy of DictationMistake
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DictationMistakeCopyWith<_DictationMistake> get copyWith => __$DictationMistakeCopyWithImpl<_DictationMistake>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DictationMistake&&(identical(other.correctSpelling, correctSpelling) || other.correctSpelling == correctSpelling)&&(identical(other.userInput, userInput) || other.userInput == userInput));
}


@override
int get hashCode => Object.hash(runtimeType,correctSpelling,userInput);

@override
String toString() {
  return 'DictationMistake(correctSpelling: $correctSpelling, userInput: $userInput)';
}


}

/// @nodoc
abstract mixin class _$DictationMistakeCopyWith<$Res> implements $DictationMistakeCopyWith<$Res> {
  factory _$DictationMistakeCopyWith(_DictationMistake value, $Res Function(_DictationMistake) _then) = __$DictationMistakeCopyWithImpl;
@override @useResult
$Res call({
 String correctSpelling, String userInput
});




}
/// @nodoc
class __$DictationMistakeCopyWithImpl<$Res>
    implements _$DictationMistakeCopyWith<$Res> {
  __$DictationMistakeCopyWithImpl(this._self, this._then);

  final _DictationMistake _self;
  final $Res Function(_DictationMistake) _then;

/// Create a copy of DictationMistake
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? correctSpelling = null,Object? userInput = null,}) {
  return _then(_DictationMistake(
correctSpelling: null == correctSpelling ? _self.correctSpelling : correctSpelling // ignore: cast_nullable_to_non_nullable
as String,userInput: null == userInput ? _self.userInput : userInput // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
