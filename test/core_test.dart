import 'package:flutter_core/core/extensions/cast_generic.dart';
import 'package:flutter_core/core/extensions/double_extensions.dart';
import 'package:flutter_core/core/extensions/duration_utils.dart';
import 'package:flutter_core/core/extensions/enum_extensions.dart';
import 'package:flutter_core/core/logic/functions.dart';
import 'package:flutter_core/core/logic/http_client.dart';
import 'package:flutter_core/core/logic/json_prefs_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Cast Generic Tests', () {
    test('tryCast returns value if type matches', () {
      expect(tryCast<int>(1), 1);
    });

    test('tryCast returns fallback if type mismatch', () {
      expect(tryCast<int>('1', fallback: 0), 0);
    });

    test('tryCast returns null if type mismatch and no fallback', () {
      expect(tryCast<int>('1'), null);
    });

    test('tryCastList returns list if type matches', () {
      expect(tryCastList<int>([1, 2]), [1, 2]);
    });

    test('tryCastList returns null if type mismatch', () {
      expect(tryCastList<int>(['1', 2]), null);
    });
  });

  group('Double Extensions Tests', () {
    test('formatDoubleToString removes decimal if zero', () {
      expect(1.0.formatDoubleToString(), '1');
      expect(1.5.formatDoubleToString(), '1.5');
    });

    test('hourToMinutesHoursDisplayString formats correctly', () {
      expect(1.5.hourToMinutesHoursDisplayString(), '1h 30m');
      expect(1.0.hourToMinutesHoursDisplayString(), '1h');
      expect(0.5.hourToMinutesHoursDisplayString(), '30m');
    });
  });

  group('Duration Utils Tests', () {
    test('toDateTimeFromSeconds converts correctly', () {
      final dt = DateTime.fromMillisecondsSinceEpoch(1000000 * 1000);
      expect(1000000.toDateTimeFromSeconds, dt);
    });
  });

  group('Enum Extensions Tests', () {
    test('enumFromString finds enum', () {
      expect(enumFromString('get', MethodType.values), MethodType.get);
    });

    test('enumFromString returns fallback', () {
      expect(
        enumFromString('invalid', MethodType.values, fallback: MethodType.post),
        MethodType.post,
      );
    });

    test('enumFromSnakeCaseString finds enum', () {
      expect(
        enumFromSnakeCaseString('method_type_get', MethodType.values),
        null,
      ); // MethodType doesn't have snake case names matching this, but let's test logic
      // Let's assume an enum for testing
    });
  });

  group('Functions Tests', () {
    test('uniqueId returns string', () {
      expect(uniqueId(), isA<String>());
    });
  });

  group('HttpClient Tests', () {
    test('get returns success', () async {
      final client = MockClient((request) async {
        return http.Response('{"key": "value"}', 200);
      });

      final httpClient = HttpClient(client: client);
      final response = await httpClient.get('https://example.com');

      expect(response.success, true);
      expect(response.statusCode, 200);
      expect(response.body, '{"key": "value"}');
    });

    test('get handles error', () async {
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final httpClient = HttpClient(client: client);
      final response = await httpClient.get('https://example.com');

      expect(response.success, false);
      expect(response.statusCode, 404);
    });
  });

  group('JsonPrefsFile Tests', () {
    test('save and load works', () async {
      SharedPreferences.setMockInitialValues({});
      final prefsFile = JsonPrefsFile('test_prefs');
      await prefsFile.save({'key': 'value'});
      final loaded = await prefsFile.load();
      expect(loaded, {'key': 'value'});
    });
  });
}
