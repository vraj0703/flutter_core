import 'package:intl/intl.dart';

extension IntFormatting on int {
  // Converts 10000 to 10,000 etc.
  String get commaFormatted {
    return NumberFormat('#,##0', 'en_US').format(this);
  }

  // Converts a negative number to 0, and leaves it alone if positive
  int get nonNegativeInteger {
    return this < 0 ? 0 : this;
  }
}
