T? tryCastWithFallback<T>(dynamic value, {T? fallback}) {
  try {
    return (value as T);
  } on TypeError catch (_) {
    return fallback;
  }
}

/// If you are certain about casting a dynamic value to a type, you can use this to force
/// the cast. There is no fall-back, and will return null instead
T? tryCastNoFallback<T>(dynamic value) {
  try {
    return (value as T);
  } on TypeError catch (_) {
    return null;
  }
}

List<T>? tryCastListNoFallback<T>(List<dynamic> value) {
  try {
    return value.cast<T>();
  } on TypeError catch (_) {
    return null;
  }
}

List<T>? castList<T>(List<dynamic>? value, T Function(dynamic) convertor) {
  if (value == null) return null;

  return value.map((e) => convertor(e)).toList();
}

Map<K, V>? castMap<K, V>(
  Map<dynamic, dynamic>? value,

  K Function(dynamic) keyConvertor,
  V Function(dynamic) valueConvertor,
) {
  if (value == null) return null;

  Map<K, V> map = {};

  value.forEach((key, value) {
    map[keyConvertor(key)] = valueConvertor(value);
  });

  return map;
}

T tryParse<T>(dynamic value, T fallback) =>
    value != null
        ? value is T
            ? tryCastWithFallback(value, fallback: fallback) ?? fallback
            : fallback
        : fallback;

T? parse<T>(dynamic value) =>
    value != null
        ? value is T
            ? tryCastNoFallback(value)
            : null
        : null;
