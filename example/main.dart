import 'dart:convert';

import 'package:merger/merger.dart';

import 'deep_equals.dart';

final Map<Object, Object?> recipient = {
  'a': 1,
  'b': '2',
  'c': false,
  'd': null,
  'e': {
    'f': 3.5,
    'g': [
      '4',
      null,
      {
        'h': [false, true, 35.5],
        'i': {1: '5'}
      }
    ],
  }
};

final Map<Object, Object?> sender = {
  'a': [1, 2, 3],
  'c': 1,
  'e': {
    'g': [
      5,
      true,
      {
        'i': {'2': 6}
      },
      36,
    ]
  },
  'j': [123],
};

final Map<String, Object?> expected = {
  'a': [1, 2, 3],
  'b': '2',
  'c': 1,
  'd': null,
  'e': {
    'f': 3.5,
    'g': [
      5,
      true,
      {
        'h': [false, true, 35.5],
        'i': {1: '5', '2': 6}
      },
      36
    ]
  },
  'j': [123]
};

void main() {
  final Map<Object, Object?> result = mergeMaps(recipient, sender);

  print(deepEquals(expected, result)); // true
}
