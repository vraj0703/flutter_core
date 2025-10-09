import 'package:flutter/material.dart';
import 'package:flutter_core/core/enums/icon_position.dart';

class ItemIconWithPosition {
  final Icon icon;
  final IconPosition iconPosition;

  ItemIconWithPosition(
      {required this.icon,
        this.iconPosition = IconPosition.left});
}
