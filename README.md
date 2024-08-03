# Merger

A Flutter package for merging `Map<K extends Object, V extends Object?>` and `List<V extends Object?>` with any deepness.

## Problem-solving
What can `merger` be useful for? The main reason for its existence is the [`easiest_localization`](https://pub.dev/packages/easiest_localization) package, of which I am also the developer. This localization package should be able to merge all available localization files to build a common localization scheme, from which an interface for all content classes will be created.

In everyday life, `merger` can be useful for changing state if the fields in it are `List<Object?>` or `Map<Object, Object?>`. Especially it can be useful if you need to change / add a field not at the first level of nesting, but deeper. Or just to change values / merge `Map`'s and `List`'s when it is not just the first level of deepness.

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

### In-map or in-list parameters

You can add the needed parameters by the last element of the list or by a special key anywhere in the map that you are going to merge with recipient. In this case, the whole subtree configuration will be overrided, according to the parameters you specify.

Inline configuration overrides the configuration defined in the function / extension-method. And also each new inline configuration overrides the inline configuration defined at a higher level of the object. But only in terms of changes defined in the same parameter.

And you can do this at any next level too. Let's look at an example:

```dart
final Map<String, Object?> recipient = {
  k1: '1',
  k2: 2,
  k3: 3.5,
  k4: false,
  k5: null,
  k6: {
    k1: '1',
    k2: 2,
    k3: 3.5,
    k4: true,
    k5: <Object>[],
    k6: ['6', 6, 6.5, false, null],
    k7: {
      k1: 1,
      k2: [
        2,
        true,
        [1, '2'],
      ],
    },
  },
};

final Map<String, Object?> donor = {
  k2: '2',
  k4: true,
  k6: {
    k1: '1',
    k3: 3.5,
    k5: <Object>[],
    k6: [
      null,
      '6',
      6.75,
      null,
      1,
      5,
      {
        NullBehavior.name: NullBehavior.remove.value, // [donor.k6.k6] and all its descendents will have [NullBehavior.remove]
      }
    ],
    k7: {
      k1: 1,
      k2: [
        2,
        true,
        [
          1,
          '2',
          {
            ListBehavior.name: ListBehavior.valueByValue, // (*) -> [donor.k6.k7.k2[2]] and all its descendents will have [ListBehavior.valueByValue]
            NullBehavior.name: NullBehavior.remove, // and also, [donor.k6.k7.k2[2]] and all its descendents will have [NullBehavior.remove]
            // and finally, [donor.k6.k7.k2[2]] and all its descendents still will have [MergeStrategy.addOnly]
          }
        ],
        [
          3,
          4,
        ],
      ],
      MergeSettings.name: {
        ListBehavior.name: ListBehavior.replaceWithNew, // [donor.k6.k7.k2] and all its descendents will have [ListBehavior.replaceWithNew], but -> (*)
        MergeStrategy.name: MergeStrategy.addOnly, // and also, [donor.k6.k7.k2] and all its descendents will have [MergeStrategy.addOnly]
      },
    },
    k8: 31,
  },
  k7: {
    k9: 1,
    k10: [
      1,
      2,
      3,
      {
        ListBehavior.name: ListBehavior.replaceWithNew.value, // [donor.k7.k10] and all its descendents will have [ListBehavior.replaceWithNew]
      }
    ],
  },
};

final Map<String, Object?> mapInlineConfigurationExample = {
  // ...some values

  // Map inline configuration should be a [Map<ParameterName, ParameterValue>], defined by the key [MergeSettings.name]
  MergeSettings.name: {
    MergeStrategy.name: MergeStrategy.addOnly, // or any of [MergeStrategy.values]
    NullBehavior.name: NullBehavior.replace, // or any of [NullBehavior.values]
    MapBehavior.name: MapBehavior.keyByKey, // or any of [MapBehavior.values]
    ListBehavior.name: ListBehavior.valueByValue, // or any of [ListBehavior.values]
    ResultBehavior.name: ResultBehavior.returnNew, // or any of [ResultBehavior.values]
  },
};

final List<Object?> listInlineConfigurationExample = [
  // ...some values

  // List inline configuration should be a [Map<ParameterName, ParameterValue>], and the last value of the List
  {
    MergeStrategy.name: MergeStrategy.addOnly, // or any of [MergeStrategy.values]
    NullBehavior.name: NullBehavior.replace, // or any of [NullBehavior.values]
    MapBehavior.name: MapBehavior.keyByKey, // or any of [MapBehavior.values]
    ListBehavior.name: ListBehavior.valueByValue, // or any of [ListBehavior.values]
    ResultBehavior.name: ResultBehavior.returnNew, // or any of [ResultBehavior.values]
  },
];
```

## Limitations

1. If Recipient Map or Recipient List is a `const List<Object?>` or `const Map<Object, Object?>`, then if you define [ResultBehavior] as a [ResultBehavior.mergeWithOld] you will get an error because `merger` will attempt to add / change values in the original constant recipient, which is not possible.
2. `merger` can only merge `List<Object?>` and `Map<Object, Object?>`. All other data types will be replaced by value, not merged. That means that if there is a class somewhere in your `Map`, for example:

```dart
final a = {
  'a': SomeClass(),
};

final b = {
  'a': SomeClass2(),
};

final c = a.mergeWith(b); // {a: SomeClass2}
```

Also, `Set` and other collection types will be replaced by value, and not merged.