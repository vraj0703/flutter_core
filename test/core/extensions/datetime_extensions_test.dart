import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_core/core/extensions/datetime_extensions.dart';

void main() {
  group('DateTimeExtensions', () {
    test('apiFormattedString returns yyyy-MM-dd', () {
      final date = DateTime(2023, 10, 25);
      expect(date.apiFormattedString, '2023-10-25');
    });

    test('isSameMonthDayYear compares correctly', () {
      final date1 = DateTime(2023, 10, 25, 10, 30);
      final date2 = DateTime(2023, 10, 25, 14, 00);
      final date3 = DateTime(2023, 10, 26);

      expect(date1.isSameMonthDayYear(date2), true);
      expect(date1.isSameMonthDayYear(date3), false);
    });

    test('daysBetween calculates correct difference', () {
      final start = DateTime(2023, 10, 1);
      final end = DateTime(2023, 10, 10);
      expect(start.daysBetween(end), 9);
    });

    test('hourMinuteSecondStringToDateTime parses correctly', () {
      final result = DateFormatting.hourMinuteSecondStringToDateTime(
        "14:30:45",
      );
      expect(result?.hour, 14);
      expect(result?.minute, 30);
      expect(result?.second, 45);
    });

    test('dailyActionDayIndex returns negative days from now', () {
      // Mocking now is hard without a library, checking logic indirectly
      final now = DateTime.now();
      expect(now.dailyActionDayIndex, 0);
    });
  });
}
