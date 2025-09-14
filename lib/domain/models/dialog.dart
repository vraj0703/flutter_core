import 'package:flutter/material.dart';

class DialogEssentials {
  final String title;
  final String? message;
  final String leftOption;
  final VoidCallback leftClicked;
  final String? rightOption; // if null means no option is shown to user
  final VoidCallback? rightClicked;

  DialogEssentials({
    required this.title,
    required this.message,
    required this.leftOption,
    required this.leftClicked,
    required this.rightOption,
    required this.rightClicked,
  });
}
