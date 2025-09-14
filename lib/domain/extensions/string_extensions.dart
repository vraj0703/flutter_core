import 'dart:math';

import 'package:flutter_core/domain/extensions/datetime_extensions.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

extension CapitalizationFormatting on String? {
  String formatUppercaseLowercase() {
    if (this == null || this!.isEmpty) {
      return '';
    }
    if (this!.length == 1) {
      return this!;
    }
    return (this!.substring(0, 1).toUpperCase() +
        this!.substring(1, this!.length).toLowerCase());
  }

  String toCapitalized() => this != null
      ? this!.isNotEmpty
            ? '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}'
            : ''
      : '';

  String toTitleCase() => this != null
      ? this!
            .replaceAll(RegExp(' +'), ' ')
            .split(' ')
            .map((str) => str.toCapitalized())
            .join(' ')
      : "";

  String withDelimiter(String delimiter, bool enable) =>
      enable && this != null ? "${this!}$delimiter " : this ?? "";

  String masker(bool yes, {String mask = '*', List<String>? omit}) {
    if (this == null) return '';
    if (!yes) return this ?? '';
    if (omit == null || omit.isEmpty) return mask * this!.length;

    var copy = this ?? '';
    var singleChar = '.';
    var output = '';

    for (var element in omit) {
      copy = copy.replaceAll(element, singleChar * element.length);
    }
    for (int i = 0; i < copy.length; i++) {
      output += copy[i] != singleChar ? mask : this![i];
    }
    return output;
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

  String? convertDateFormat(String newFormat) {
    DateTime? dateTime = DateTime.tryParse(this);
    return dateTime?.dateString(newFormat);
  }

  String? convertISODateFormat(String newFormat, {int daysToBeAdded = 0}) {
    DateTime? dateTime = tryParsingIsoDate;
    if (daysToBeAdded != 0 && dateTime != null) {
      dateTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day + daysToBeAdded,
      );
    }
    return dateTime?.dateString(newFormat);
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
    List.generate(len, (index) => r.nextInt(33) + 89),
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
