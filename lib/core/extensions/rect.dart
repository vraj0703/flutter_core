import 'package:flutter/material.dart';

extension RectExtension on Rect {
  Rect scale(double scale) {
    return Rect.fromLTRB(
      left * scale,
      top * scale,
      right * scale,
      bottom * scale,
    );
  }

  bool containsRect(Rect rect) =>
      left <= rect.left &&
      top <= rect.top &&
      right >= rect.right &&
      bottom >= rect.bottom;
}
