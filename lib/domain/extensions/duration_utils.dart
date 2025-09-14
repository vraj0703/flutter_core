import 'package:flutter_core/data/di/strings.dart';
import 'package:flutter_core/domain/extensions/string_extensions.dart';

extension DurationExtensions on int {
  Duration get delayMs => Duration(milliseconds: this);

  Duration get animateMs => Duration(milliseconds: this);

  DateTime get dateTime {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000);
  }
}

class DateConstants {
  static String today = $strings.today;

  static String getTodayWithTime(String time) {
    return '${DateConstants.today}, $time';
  }

  static String getDateRangeinFormat(
      String startDateString, String endDateString, String format,
      {int ignoredStartDays = 0}) {
    String startDateFormattedString = startDateString
        .convertISODateFormat(format, daysToBeAdded: ignoredStartDays) ??
        "";
    String endDateFormattedString =
        endDateString.convertISODateFormat(format) ?? "";

    List<String> startDateSplit = startDateFormattedString.split(' ');
    List<String> endDateSplit = endDateFormattedString.split(' ');

    if (startDateSplit.length == 2 && endDateSplit.length == 2) {
      // Check both month are equal
      if (startDateSplit[0].isNotEmpty &&
          startDateSplit[0] == endDateSplit[0]) {
        // This is to convert Feb 5–Feb 11 => Feb 5-11
        return "${startDateSplit[0]} ${startDateSplit[1]}–${endDateSplit[1]}";
      }
    }
    return "$startDateFormattedString–$endDateFormattedString"; // Jan 29–Feb 4
  }
}
