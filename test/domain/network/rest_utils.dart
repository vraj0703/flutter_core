import 'package:flutter_core/domain/network/rest_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RestUtils', () {
    group('encodeParams', () {
      test('with empty params returns empty string', () {
        final params = <String, String>{};
        final result = RestUtils.encodeParams(params);
        expect(result, '');
      });

      test('with single param returns correct string', () {
        final params = {'key1': 'value1'};
        final result = RestUtils.encodeParams(params);
        expect(result, '?key1=value1');
      });

      test('with multiple params returns correct string', () {
        final params = {'key1': 'value1', 'key2': 'value2'};
        final result = RestUtils.encodeParams(params);
        expect(result, '?key1=value1&key2=value2');
      });

      test('with empty value param is skipped', () {
        final params = {'key1': 'value1', 'key2': ''};
        final result = RestUtils.encodeParams(params);
        expect(result, '?key1=value1');
      });

      test('with "null" value param is skipped', () {
        final params = {'key1': 'value1', 'key2': 'null'};
        final result = RestUtils.encodeParams(params);
        expect(result, '?key1=value1');
      });
    });
  });
}