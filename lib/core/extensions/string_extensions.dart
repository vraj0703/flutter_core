import 'dart:math';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

extension CapitalizationFormatting on String? {
  String formatUppercaseLowercase() {
    if (this == null || this!.isEmpty) return '';
    if (this!.length == 1) return this!.toUpperCase();
    return this![0].toUpperCase() + this!.substring(1).toLowerCase();
  }

  String toCapitalized() {
    if (this == null || this!.isEmpty) return '';
    return '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}';
  }

  String toTitleCase() {
    if (this == null || this!.isEmpty) return '';
    return this!
        .replaceAll(RegExp(' +'), ' ')
        .trim()
        .split(' ')
        .map((str) => str.toCapitalized())
        .join(' ');
  }

  String withDelimiter(String delimiter, bool enable) =>
      enable && this != null ? "${this!}$delimiter " : this ?? "";

  String masker(bool yes, {String mask = '*', List<String>? omit}) {
    if (this == null) return '';
    if (!yes) return this!;

    // If no specific chars to omit, mask everything
    if (omit == null || omit.isEmpty) {
      return mask * this!.length;
    }

    // Mask specific characters
    // Optimize: Single pass replacement
    String result = this!;
    for (var charToMask in omit) {
      result = result.replaceAll(charToMask, mask * charToMask.length);
    }
    return result;
  }

  String injectMap(Map<String, String> map) {
    if (this == null) return "";
    var ans = this!;
    map.forEach((key, value) {
      ans = ans.replaceFirst(key, value);
    });
    return ans;
  }
}

const dateTimeFormatHHmmss = "HH:mm:ss";

extension StringToDateFormatting on String {
  DateTime get mdyDate {
    return DateFormat('yyyy-MM-dd').parse(this);
  }

  DateTime? get tryParsingIsoDate {
    try {
      return DateTime.parse(this);
    } on Exception {
      return null;
    }
  }

  String numberFormat() {
    var canBeNumber = double.tryParse(this);
    if (canBeNumber != null) {
      NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
      return myFormat.format(canBeNumber);
    }
    return this;
  }

  DateTime? dateTimeInFormat(String format) {
    if (isEmpty) {
      return null;
    }
    return DateFormat(format).parse(this);
  }

  DateTime? dateTimeInFormatLocal(String format) {
    if (isEmpty) {
      return null;
    }
    return DateFormat(format).parse(this, true).toLocal();
  }

  // Converts given date String "yyyy-MM-dd'T'HH:mm:ssZ" to date
  DateTime getFormattedDate() {
    var dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
    var dateTime = dateFormatter.parseUtc(this).toLocal();
    return dateTime;
  }
}

extension StringState on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullAndEmpty => !isNullOrEmpty;
}

String randomString(int len) {
  var r = Random();
  return String.fromCharCodes(
    List.generate(len, (index) => r.nextInt(26) + 65), // A-Z range optimization
  );
}

extension StringFirstCharCapitalization on String? {
  String getFirstLetter() {
    if (this != null && this!.isNotEmpty) {
      return this!.substring(0, 1);
    }
    return '';
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == "true";
  }
}

extension HexToColor on String {
  // convert string like #ECB000 into color
  Color get hexToColor {
    return Color(
      int.parse(toLowerCase().substring(1, 7), radix: 16) + 0xFF000000,
    );
  }
}
