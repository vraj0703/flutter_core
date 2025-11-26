# Flutter Core

A comprehensive Flutter core library providing essential utilities, extensions, and base classes for building robust Flutter applications.

## Features

- **Extensions**:
  - `String`: Capitalization, masking, date parsing, and more.
  - `double` / `int`: Formatting, unit conversion.
  - `Duration`: Easy conversion from integers.
  - `List` / `Map`: Type-safe casting and utilities.
  - `Enum`: Robust string-to-enum parsing.
- **Network**:
  - `HttpClient`: A wrapper around `http` for easier testing and error handling.
  - `RestApiClient`: Base class for REST API interactions.
- **Logic**:
  - `Throttler`: Limit function execution frequency.
  - `JsonPrefsFile`: Simple JSON-based file storage using `SharedPreferences`.
  - `PlatformInfo`: Easy access to platform checks.
- **Models**:
  - `Pair`, `Stack`, `Unit`, `None`: Functional programming primitives.
  - `UserInfo`, `BootLoad`: Common application models.

## Getting Started

Add `flutter_core` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_core:
    path: ../flutter_core # Or git url
```

## Usage

### Extensions

```dart
import 'package:flutter_core/core/extensions/string_extensions.dart';

void main() {
  print('hello world'.toCapitalized()); // Hello world
  print('12345'.masker(true, mask: '*', omit: ['1', '5'])); // 1***5
}
```

### HttpClient

```dart
import 'package:flutter_core/core/logic/http_client.dart';

void main() async {
  final client = HttpClient();
  final response = await client.get('https://api.example.com/data');
  
  if (response.success) {
    print(response.body);
  }
}
```

### Throttler

```dart
import 'package:flutter_core/core/logic/throttler.dart';

final throttler = Throttler(Duration(seconds: 1));

void onButtonClick() {
  throttler(() {
    print('Button clicked!');
  });
}
```
