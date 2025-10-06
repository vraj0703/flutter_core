class Unit {
  const Unit._(); // Private constructor to prevent instantiation.

  /// A constant representing a singular, empty value.
  static const Unit unit = Unit._();
}

class None {
  const None._(); // Private constructor to prevent instantiation.

  /// A constant representing the absence of a value, similar to `null`.
  static const None nil = None._();
}

/// A top-level constant for the canonical `unit` value.
const unit = Unit.unit;

/// A top-level constant for the canonical `nil` value.
const nil = None.nil;
