import 'package:intl/intl.dart';

extension DoubleFormatting on double {
  double get metersToFeet => this * 3.28084;

  double get metersToMiles => this * 0.000621371;

  double get msToMph => this * 2.23694;

  // Converts 10000 to 10,000 etc.
  String get commaFormatted {
    return NumberFormat('#,##0', 'en_US').format(this);
  }

  String get commaFormattedDecimal {
    return NumberFormat('#,##0', 'en_US').format(this);
  }

  /// If we are returned a double, that is 1.0 or 5.0, we can return a string dropping the
  /// last decimal so the UI will look better
  String formatDoubleToString() {
    int floor = this.floor();
    double remainder = this - floor;
    if ((remainder / 0.1) == 0) {
      return toStringAsFixed(0);
    } else {
      return toString();
    }
  }

  String formattedToString(int maxDecimalCount) {
    NumberFormat numberFormat = NumberFormat.decimalPattern();
    numberFormat.maximumFractionDigits = maxDecimalCount;
    return numberFormat.format(this);
  }

  // Takes a double in hours (i.e. 2.1 hours), converts it to Minutes and Hours format (i.e. 3h 20m, 20m)
  String? hourToMinutesHoursDisplayString() {
    int hours = Duration(minutes: (this * 60).toInt()).inHours;
    int minutes = Duration(
      minutes: (this * 60).toInt(),
    ).inMinutes.remainder(60);
    return _minutesHoursDisplayString(hours, minutes);
  }

  // Get inputs in minutes, converts it to Minutes and Hours format
  String get minutesToHoursDisplayString {
    var time = Duration(minutes: toInt());
    int hours = time.inHours;
    int minutes = time.inMinutes.remainder(60);
    return _minutesHoursDisplayString(hours, minutes);
  }

  String _minutesHoursDisplayString(int hours, int minutes) {
    if (hours == 0) {
      return '${minutes}m';
    } else {
      if (minutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${minutes}m';
      }
    }
  }
}
