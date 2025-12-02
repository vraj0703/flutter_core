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

  int get unixTimeStamp {
    return millisecondsSinceEpoch ~/ 1000;
  }

  int get dailyActionDayIndex {
    return -daysBetween(DateTime.now());
  }

  bool get isThisWeekDate {
    var date = DateTime.now();
    date = DateTime(date.year, date.month, date.day);
    var firstDay = date.subtract(Duration(days: date.weekday - 1));
    var lastDay = date.add(
      Duration(days: DateTime.daysPerWeek - date.weekday + 1),
    );
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

  String dateToStringConverter({required DateFormat formatter}) {
    return formatter.format(this);
  }

  static List<DateTime> getDateTimeList({
    required int startDateOffset,
    required int endDateOffset,
  }) {
    List<DateTime> dateTimeList = [];
    for (
      var dateOffset = startDateOffset;
      dateOffset >= endDateOffset;
      dateOffset--
    ) {
      DateTime scoreDate = DateTime.now().subtract(Duration(days: dateOffset));
      dateTimeList.add(scoreDate);
    }
    return dateTimeList;
  }

  bool isContainedInRange({
    required DateTime startTime,
    required DateTime endTime,
  }) {
    return isAtSameMomentAs(startTime) ||
        isAtSameMomentAs(endTime) ||
        (isAfter(startTime) && isBefore(endTime));
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
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
      currentYear,
      currentMonth,
      currentDay,
      hour,
      minute,
      second,
    );
  }

  String hourMinuteSecondDateTimeToHourMinuteString() {
    final DateFormat format = DateFormat('h:mm a');
    return format.format(this);
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

  /// Returns "01-23-24" format
  String mmddyyString() {
    return dateToStringConverter(formatter: DateFormat('MM-dd-yy'));
  }

  DateTime dayStart() {
    return DateTime(year, month, day, 00, 00, 01);
  }

  DateTime dayEnd() {
    return DateTime(year, month, day, 23, 59, 59);
  }
}

extension DateTimeStampFormatting on int {
  DateTime get dateTime {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000);
  }
}
