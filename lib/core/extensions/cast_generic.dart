T? tryCast<T>(dynamic value, {T? fallback}) {
  try {
    if (value is T) return value;
    return fallback;
  } catch (_) {
    return fallback;
  }
}

/// If you are certain about casting a dynamic value to a type, you can use this to force
/// the cast. There is no fall-back, and will return null instead
T? tryCastNoFallback<T>(dynamic value) {
  return tryCast<T>(value);
}

List<T>? tryCastList<T>(List<dynamic>? value) {
  if (value == null) return null;
  try {
    return value.cast<T>().toList();
  } catch (_) {
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
  return value.map((k, v) => MapEntry(keyConvertor(k), valueConvertor(v)));
}

T tryParse<T>(dynamic value, T fallback) {
  if (value == null) return fallback;
  if (value is T) return value;
  return tryCast<T>(value, fallback: fallback) ?? fallback;
}

T? parse<T>(dynamic value) {
  if (value == null) return null;
  if (value is T) return value;
  return tryCast<T>(value);
}
