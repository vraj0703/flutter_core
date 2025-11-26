import 'dart:math' as math;

import 'dart:ui';

String uniqueId({int max = 100000}) =>
    math.Random.secure().nextInt(max).toString();

Color randomColor() =>
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withValues(alpha: 1);

/// Returns the current time in microseconds since epoch as a string.
String timestampId() => DateTime.now().microsecondsSinceEpoch.toString();
