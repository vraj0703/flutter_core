import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

extension DateFormatting on DateTime {
  String get apiFormattedString {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  // Optimized: returns a new DateTime with time stripped
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
    DateTime target = DateTime(to.year, to.month, to.day);
    return (target.difference(from).inHours / 24).round();
  }

  bool get isDateToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isDateYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isDateTodayOrYesterday => isDateToday || isDateYesterday;

  DateTime get getYearBefore => subtract(const Duration(days: 365));
  DateTime get getYearAfter => add(const Duration(days: 365));

  TZDateTime timeZoneTs(String timezone) {
    return TZDateTime.from(this, getLocation(timezone));
  }

  // Renamed/Aliased for clarity or specific usage contexts, keeping original logic
  DateTime graphDataFormat() => mdyFormat();

  TZDateTime graphDataFormatTz(String timezone) {
    return TZDateTime(getLocation(timezone), year, month, day);
  }

  // Alias for UTC format
  DateTime graphFormattedUTC() => mdyUTCFormat();

  DateTime cgmGraphFormat() {
    return DateTime(year, month, day, hour, minute, second);
  }

  int totalSecondsInDay() {
    return (hour * 3600) + (minute * 60) + second;
  }

  String get dateWithTimeZone {
    final formatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(this);
    return '$formatted${formattedTimeZoneOffset()}';
  }

  String formattedTimeZoneOffset() {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final duration = toLocal().timeZoneOffset;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).abs().toInt();
    return '${hours > 0 ? '+' : '-'}${twoDigits(hours.abs())}:${twoDigits(minutes)}';
  }

  int get unixTimeStamp => millisecondsSinceEpoch ~/ 1000;

  int get dailyActionDayIndex => -daysBetween(DateTime.now());

  bool get isThisWeekDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Week starts on Monday (1) or Sunday (7)? Logic implies standard ISO week
    final firstDay = today.subtract(Duration(days: today.weekday - 1));
    final lastDay = today.add(
      Duration(days: DateTime.daysPerWeek - today.weekday + 1),
    );
    return isAfter(firstDay) && isBefore(lastDay);
  }

  bool get isInLast6Days {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sevenDaysAgo = today.subtract(const Duration(days: 6));
    return isAfter(sevenDaysAgo);
  }

  bool get isThisYearDate => year == DateTime.now().year;

  String dateToStringConverter({required DateFormat formatter}) {
    return formatter.format(this);
  }

  static List<DateTime> getDateTimeList({
    required int startDateOffset,
    required int endDateOffset,
  }) {
    List<DateTime> dateTimeList = [];
    final now = DateTime.now();
    for (
      var dateOffset = startDateOffset;
      dateOffset >= endDateOffset;
      dateOffset--
    ) {
      dateTimeList.add(now.subtract(Duration(days: dateOffset)));
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

  bool isSameDate(DateTime other) => isSameMonthDayYear(other);

  static DateTime? hourMinuteSecondStringToDateTime(String timeString) {
    final List<String> timeComponents = timeString.split(':');

    if (timeComponents.length != 3) {
      return null;
    }

    final int? hour = int.tryParse(timeComponents[0]);
    final int? minute = int.tryParse(timeComponents[1]);
    final int? second = int.tryParse(timeComponents[2]);

    if (hour == null || minute == null || second == null) return null;

    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute, second);
  }

  String hourMinuteSecondDateTimeToHourMinuteString() {
    final DateFormat format = DateFormat('h:mm a');
    return format.format(this);
  }

  DateTime mostRecentWeekday(int weekday) {
    return DateTime.utc(year, month, day - (this.weekday - weekday) % 7);
  }

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
