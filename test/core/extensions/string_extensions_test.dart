import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core/extensions/string_extensions.dart';

void main() {
  group('StringExtensions', () {
    test(
      'formatUppercaseLowercase capitalizes first letter and lowercases rest',
      () {
        expect('HELLO'.formatUppercaseLowercase(), 'Hello');
        expect('world'.formatUppercaseLowercase(), 'World');
        expect(''.formatUppercaseLowercase(), '');
        expect(null.formatUppercaseLowercase(), '');
      },
    );

    test('toCapitalized capitalizes first letter', () {
      expect('hello'.toCapitalized(), 'Hello');
      expect(''.toCapitalized(), '');
    });

    test('toTitleCase capitalizes each word', () {
      expect('hello world'.toTitleCase(), 'Hello World');
      expect('  hello   world  '.toTitleCase(), 'Hello World');
    });

    test('masker masks string correctly', () {
      expect('123456'.masker(true), '******');
      expect('123456'.masker(true, mask: '#'), '######');
      expect('123456'.masker(false), '123456');
      expect('123456'.masker(true, omit: ['2', '5']), '1*34*6');
    });

    test('hexToColor converts correctly', () {
      expect('#FF0000'.hexToColor.value, const Color(0xFFFF0000).value);
      expect('#00FF00'.hexToColor.value, const Color(0xFF00FF00).value);
    });
  });
}
