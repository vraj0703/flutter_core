import 'package:flutter/cupertino.dart';
import 'package:flutter_core/data/di/strings.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

extension DateFormatting on DateTime {
  String get apiFormattedString {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  DateTime mdyFormat() {
    return DateTime(year, month, day);
  }

  DateTime mdyUTCFormat() {
    return DateTime.utc(year, month, day);
  }

  static DateFormat hourMinuteSecondFormat() {
    return DateFormat('HH:mm:ss', $strings.localeName);
  }

  bool isSameMonthDayYear(DateTime comparison) {
    return year == comparison.year &&
        month == comparison.month &&
        day == comparison.day;
  }

  int daysBetween(DateTime to) {
    DateTime from = DateTime(year, month, day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  bool get isDateToday {
    var date = DateTime.now();
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isDateYesterday {
    var date = DateTime.now().subtract(const Duration(days: 1));
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isDateTodayOrYesterday {
    return isDateToday || isDateYesterday;
  }

  DateTime get getYearBefore =>
      subtract(const Duration(days: 365)); // 1 year before
  DateTime get getYearAfter => add(const Duration(days: 365)); // 1 year after

  // MON, TUE, WED, ...
  String get weekDayName =>
      DateFormat('EEE', $strings.localeName).format(this);

  String get weekDayFullName =>
      DateFormat('EEEE', $strings.localeName).format(this);

  String get englishWeekdayFullName {
    return DateFormat('EEEE', 'en_US').format(this);
  }

  String get weeDayFirstLetter {
    final dayName = weekDayFullName;
    // IN Spanish weekdays are Domingo, Lunes, Martes, Miércoles, Jueves, Viernes, Sábado → DLMMJVS
    // To avoid confusion of two 'M" subsequently,'X' is often used in Spanish
    if (dayName.toLowerCase() == "miércoles") {
      return "X";
    } else {
      return dayName.characters.first.toUpperCase();
    }
  }

  // JAN, FEB, MAR, ...
  String get monthName => DateFormat('MMM', $strings.localeName).format(this);

  TZDateTime timeZoneTs(String timezone) {
    return TZDateTime.from(this, getLocation(timezone));
  }

  //new instance of DateTime, does not hold timezone
  DateTime graphDataFormat() {
    return DateTime(year, month, day);
  }

  TZDateTime graphDataFormatTz(String timezone) {
    return TZDateTime(getLocation(timezone), year, month, day);
  }

  //new instance of DateTime, as UTC date
  DateTime graphFormattedUTC() {
    return mdyUTCFormat();
  }

  DateTime cgmGraphFormat() {
    return DateTime(year, month, day, hour, minute, second);
  }

  int totalSecondsInDay() {
    return (hour * 3600) + (minute * 60) + second;
  }

  String amPmString() {
    DateFormat formatter = DateFormat('h:mm a', $strings.localeName);
    return formatter.format(this);
  }


  String dateString(String format) {
    return DateFormat(format, $strings.localeName).format(this);
  }

  String get formattedFullString {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", $strings.localeName)
        .format(this);
  }

  String get dateWithTimeZone {
    var formatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(this);
    return '$formatted${formattedTimeZoneOffset()}';
  }


  String formattedTimeZoneOffset() {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final duration = toLocal().timeZoneOffset,
        hours = duration.inHours,
        minutes = duration.inMinutes.remainder(60).abs().toInt();
    return '${hours > 0 ? '+' : '-'}${twoDigits(hours.abs())}:${twoDigits(minutes)}';
  }

  // 28 Aug 02:30 PM
  String get displayDate {
    return DateFormat("dd MMM hh:mm a", $strings.localeName).format(this);
  }

  int get unixTimeStamp {
    return millisecondsSinceEpoch ~/ 1000;
  }

  bool get isThisWeekDate {
    var date = DateTime.now();
    date = DateTime(date.year, date.month, date.day);
    var firstDay = date.subtract(Duration(days: date.weekday - 1));
    var lastDay =
        date.add(Duration(days: DateTime.daysPerWeek - date.weekday + 1));
    return isAfter(firstDay) && isBefore(lastDay);
  }

  bool get isInLast6Days {
    var date = DateTime.now();
    date = DateTime(date.year, date.month, date.day);
    var sevenDaysAgo = date.subtract(const Duration(days: 6));
    return isAfter(sevenDaysAgo);
  }

  bool get isThisYearDate {
    var date = DateTime.now();
    return year == date.year;
  }

  String formattedTimeDifference(
      {bool isUS = false,
      required String hourSuffix,
      required String minSuffix,
      required String nowString,
      bool isWeekDayWithTime = false,
      bool is7DayWeekFormat = false,
      bool showToday = true}) {
    if (isDateToday) {
      DateTime now = DateTime.now();
      var differenceInHours = difference(now).inHours.abs();
      var differenceInMins = difference(now).inMinutes.abs();
      if (differenceInHours > 12 || showToday) {
        return $strings.today;
      } else if (differenceInHours > 0) {
        return '$differenceInHours$hourSuffix';
      } else if (differenceInMins > 2) {
        return '$differenceInMins$minSuffix';
      } else {
        return nowString;
      }
    } else if (isDateYesterday) {
      return $strings.yesterday;
    } else if (isThisWeekDate || (isInLast6Days && is7DayWeekFormat)) {
      if (isWeekDayWithTime) {
        //EX: Wed 11:46 am
        return DateFormat('E h:mm aa', $strings.localeName)
            .format(this)
            .replaceAll("AM", "am")
            .replaceAll("PM", "pm");
      }

      // EX: MON, TUE, WED, ...
      return DateFormat('EEEE', $strings.localeName).format(this);
    } else {
      var format = isUS ? 'MMM d' : 'd MMM';
      if (!isThisYearDate) {
        format += ' yyyy';
      }
      return DateFormat(format, $strings.localeName).format(this);
    }
  }



  //Ex: 18 Jun, 2024
  String formattedDayMonthYearDate() {
    return DateFormat('dd MMM, yyyy', $strings.localeName).format(this);
  }

  String formattedMonthDayYear() {
    return DateFormat("MMM dd, yyyy", $strings.localeName).format(this);
  }

  String dateToStringConverter({required DateFormat formatter}) {
    return formatter.format(this);
  }


  static List<DateTime> getDateTimeList(
      {required int startDateOffset, required int endDateOffset}) {
    List<DateTime> dateTimeList = [];
    for (var dateOffset = startDateOffset;
        dateOffset >= endDateOffset;
        dateOffset--) {
      DateTime scoreDate = DateTime.now().subtract(Duration(days: dateOffset));
      dateTimeList.add(scoreDate);
    }
    return dateTimeList;
  }

  /// Returns "Jan 2", "Jan 31" format
  String mMMddString() {
    return dateToStringConverter(
        formatter: DateFormat('MMM d', $strings.localeName));
  }

  bool isContainedInRange(
      {required DateTime startTime, required DateTime endTime}) {
    return isAtSameMomentAs(startTime) ||
        isAtSameMomentAs(endTime) ||
        (isAfter(startTime) && isBefore(endTime));
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String dayString() {
    if (isDateToday) {
      return $strings.today;
    } else if (isDateYesterday) {
      return $strings.yesterday;
    } else {
      return dateToStringConverter(
          formatter: DateFormat("EEEE", $strings.localeName));
    }
  }

  static DateTime? hourMinuteSecondStringToDateTime(String timeString) {
    final List<String> timeComponents = timeString.split(':');

    if (timeComponents.length != 3) {
      return null;
    }

    final int hour = int.tryParse(timeComponents[0]) ?? 0;
    final int minute = int.tryParse(timeComponents[1]) ?? 0;
    final int second = int.tryParse(timeComponents[2]) ?? 0;

    final DateTime now = DateTime.now();

    final int currentYear = now.year;
    final int currentMonth = now.month;
    final int currentDay = now.day;

    return DateTime(
        currentYear, currentMonth, currentDay, hour, minute, second);
  }

  String hourMinuteSecondDateTimeToString() {
    final DateFormat format = hourMinuteSecondFormat();
    return format.format(this);
  }

  String hourMinuteSecondDateTimeToHourMinuteString() {
    final DateFormat format = DateFormat('h:mm a');
    return format.format(this);
  }

  // Given the start date (this), returns the string display of the range
  // Given: 3/24/24 and 3/29/24, this would return Mar 24 - 29
  // Given: 3/24/24 and 4/5/24, this would return Mar 24 - Apr - 5
  String monthDayDateRangeFormat(DateTime endDate) {
    final DateFormat mdFormat = DateFormat('MMM d', $strings.localeName);
    String md = mdFormat.format(this);
    // same month, can omit the second month
    if (month == endDate.month) {
      return '$md - ${endDate.day}';
    } else {
      // different months
      String formattedEnd = mdFormat.format(endDate);
      return '$md - $formattedEnd';
    }
  }

  /// Returns the most recent date for a given [weekday].
  /// The [weekday] is expected to be in the range 1 (Monday) to 7 (Sunday),
  /// as defined in the DateTime class.
  ///
  /// Example: Calling `DateTime.now().mostRecentWeekday(1)` will return
  /// the most recent Monday.
  DateTime mostRecentWeekday(int weekday) {
    return DateTime.utc(year, month, day - (this.weekday - weekday) % 7);
  }

  /// Returns "Jan 2, 2024", "Jan 31, 2024" format
  String mMMddyyyyString() {
    return dateToStringConverter(
        formatter: DateFormat('MMM d, yyyy', $strings.localeName));
  }

  /// Returns "01-23-24" format
  String mmddyyString() {
    return dateToStringConverter(formatter: DateFormat('MM-dd-yy'));
  }

// Returns given date to Mon, Jan 15, 10:20 PM
  String getDayMonthDateTimeFormattedString() {
    return dateToStringConverter(
        formatter: DateFormat("EEE, MMM dd, hh:mm a", $strings.localeName));
  }

  String getDayMonthDateFormattedString() {
    return dateToStringConverter(
        formatter: DateFormat("EEE, MMM dd", $strings.localeName));
  }

  /// Returns "Tue, Oct 8" format
  String weekMonthDateString() {
    return dateToStringConverter(
        formatter: DateFormat('EEE, MMM d', $strings.localeName));
  }

  DateTime dayStart() {
    return DateTime(year, month, day, 00, 00, 01);
  }

  DateTime dayEnd() {
    return DateTime(year, month, day, 23, 59, 59);
  }
}
