import 'dart:math' as math;

import 'dart:ui';

String uniqueId() => math.Random().nextInt(100000).toString();

Color randomColor() =>
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
