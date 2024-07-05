// String, int, double, bool, null,

import 'package:merger/src/settings.dart';

import 'keys.dart';

final Map<String, Object?> map1 = {
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

final Map<String, Object?> map2 = {
  k2: '2',
  k4: true,
  k6: {
    k1: '1',
    k3: 3.5,
    k5: <Object>[],
    k6: [null, '6', 6.75, null, 1, 5],
    k7: {
      k1: 1,
      k2: [
        2,
        true,
        [1, '2'],
      ],
    },
    k8: 31,
  },
  k7: {
    k1: 1,
    k2: [1, '2', null, false],
  },
};

final Map<String, Object?> map3 = {
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
        NullBehavior.name: NullBehavior.remove.value,
      }
    ],
    k7: {
      k1: 1,
      k2: [
        2,
        true,
        [1, '2'],
      ],
    },
    k8: 31,
  },
  k7: {
    k1: 1,
    k2: [
      1,
      2,
      3,
      {
        ListBehavior.name: ListBehavior.replaceWithNew.value,
      }
    ],
  },
};

final List<Object?> list1 = [
  1,
  '2',
  false,
  null,
  [1, '2', true, null],
  {
    k1: 1,
    k2: '2',
    k3: false,
    k4: null,
    k5: [
      1,
      '2',
      true,
      {
        k1: 1,
        k2: '2',
        k3: null,
      }
    ],
  },
];

final List<Object?> list2 = [
  null,
  3,
  true,
  '4',
  [
    1,
    null,
    true,
    null,
    '5',
    {
      k1: 1,
      k2: [1, '2']
    }
  ],
  {
    k2: '3',
    k3: null,
    k4: null,
    k5: [
      1,
      null,
      false,
      {
        k1: 1,
        k2: '3',
        k3: null,
      }
    ],
  },
];
