extension JsonParsing on Map {
  String? getOptString(String key) {
    if (this[key] != null && (this[key] is String)) {
      return this[key];
    }
    return null;
  }

  DateTime? getOptDate(String key) {
    if (this[key] != null) {
      return DateTime.tryParse(this[key])?.toLocal();
    }
    return null;
  }

  int? getOptInt(String key) {
    if (this[key] != null && (this[key] is int)) {
      return this[key];
    }
    return null;
  }

  bool getBool(String key) {
    if (this[key] != null && (this[key] is bool)) {
      return this[key];
    }
    return false;
  }
}
