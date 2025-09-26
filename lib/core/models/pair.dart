import 'package:flutter/material.dart';

@immutable
class Pair<T, R> {
  const Pair(this.left, this.right);

  final T left;

  final R right;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Optimization: same instance
    return other is Pair<T, R> && // Check type and generic types
        other.left == left &&
        other.right == right;
  }

  @override
  int get hashCode => left.hashCode ^ right.hashCode;

  @override
  String toString() => 'Pair[$left, $right]';
}
