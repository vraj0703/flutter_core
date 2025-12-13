import 'package:dart_either/dart_either.dart';
import 'package:flutter/widgets.dart';

extension EitherExtensions<L, R> on Either<L, R> {
  R getRight() => (this as Right<L, R>).value;
  L getLeft() => (this as Left<L, R>).value;

  // For use in UI to map to different widgets based on success/failure
  Widget when({
    required Widget Function(L failure) failure,
    required Widget Function(R data) success,
  }) {
    return fold(ifLeft: (l) => failure(l), ifRight: (r) => success(r));
  }

  // Simplify chaining operations that can fail
  Either<L, T> flatMap<T>(Either<L, T> Function(R r) f) {
    return fold(ifLeft: (l) => Left(l), ifRight: (r) => f(r));
  }
}
