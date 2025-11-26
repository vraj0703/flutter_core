import 'package:collection/collection.dart';

/// These methods will allow us to go from String -> Enum
/// Any enum value, when cast toString() will look like ENUM_NAME.ENUM_VALUE
/// Given enum ABC { yash } -> yash.toString == ABC.yash
/// We can then split the string by '.', take the last value and see if the passed in value matches
/// Below provides a method that takes in a fallback (similar to CaseIterableLast) or can also return null

T enumFromStringWithFallback<T>(
  String? value,
  Iterable<T> values, {
  required T fallback,
}) {
  if (value == null) return fallback;
  return values.firstWhere(
    (type) => _enumName(type) == value,
    orElse: () => fallback,
  );
}

T? enumFromStringNoFallback<T>(String? value, Iterable<T> values) {
  if (value == null) return null;
  return values.firstWhereOrNull((type) => _enumName(type) == value);
}

// ex. Converts strings like 'off_track' or 'Off_Track' to <Enum>.offTrack
// returns null if no match found
T? enumFromSnakeCaseString<T>(String? value, Iterable<T> values) {
  if (value == null) return null;
  final normalizedValue = value.replaceAll('_', '').toLowerCase();
  return values.firstWhereOrNull(
    (type) => _enumName(type).toLowerCase() == normalizedValue,
  );
}

T? enumFromString<T extends Enum>(
  String? value,
  Iterable<T> values, {
  T? fallback,
}) {
  if (value == null) return fallback;
  return values.firstWhereOrNull((type) => type.name == value) ?? fallback;
}

String _enumName(dynamic enumValue) {
  if (enumValue is Enum) return enumValue.name;
  return enumValue.toString().split('.').last;
}
