# Merger

A Flutter package for merging `Map<K extends Object, V extends Object?>` and `List<V extends Object?>` with any deepness.

## How to use merger

There are two ways of using it - functions and extension methods.

### Functions

#### Maps

```dart
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
```

#### Lists

```dart
import 'package:merger/merger.dart';

import 'deep_equals.dart';
import 'main.dart' as m;

void main() {
  final List<Object?> recipient = [
    m.recipient,
  ];

  final List<Object?> sender = [
    m.sender,
  ];

  final List<Object?> result = mergeLists(recipient, sender);

  final List<Object?> expected = [
    m.expected,
  ];

  print(deepEquals(expected, result)); // true
}
```

### Extension methods

```dart
import 'package:merger/merger.dart';

import 'deep_equals.dart';
import 'main.dart' as m;

void main() {
  final List<Object?> recipientList = [m.recipient];
  final List<Object?> senderList = [m.sender];

  final List<Object?> resultList = recipientList.mergeWith(senderList);

  final Map<Object, Object?> resultMap = m.recipient.mergeWith(m.sender);
}
```

## Configuration

Configuration is also possible in two ways. The second way complements the first, allowing you to customize your merge strategy in a very flexible way (if you need it).

### Functions / Extension methods arguments

```dart
import 'package:merger/merger.dart';

import 'main.dart' as m;

void main() {
  final Map<Object, Object?> resultMap = m.recipient.mergeWith(
    m.sender,
    strategy: MergeStrategy.addAndOverride,
    resultBehavior: ResultBehavior.returnNew,
    listBehavior: ListBehavior.replaceWithNew,
    mapBehavior: MapBehavior.replaceWithNew,
    nullBehavior: NullBehavior.doNothing,
  );

  final List<Object?> resultList = [m.recipient].mergeWith(
    [m.sender],
    strategy: MergeStrategy.addAndOverride,
    resultBehavior: ResultBehavior.returnNew,
    listBehavior: ListBehavior.replaceWithNew,
    mapBehavior: MapBehavior.replaceWithNew,
    nullBehavior: NullBehavior.doNothing,
  );

  print(MergeStrategy.values); // [MergeStrategy.addOnly, MergeStrategy.overrideOnly, MergeStrategy.addAndOverride]
  print(ResultBehavior.values); // [ResultBehavior.returnNew, ResultBehavior.mergeWithOld]
  print(ListBehavior.values); // [ListBehavior.replaceWithNew, ListBehavior.valueByValue]
  print(MapBehavior.values); // [MapBehavior.replaceWithNew, MapBehavior.keyByKey]
  print(NullBehavior.values); // [NullBehavior.replace, NullBehavior.doNothing, NullBehavior.remove]
}

```

