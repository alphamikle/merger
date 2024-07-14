// String, int, double, bool, null,

import 'package:merger/src/settings.dart';

import 'keys.dart';

Map<String, Object?> get map1 => {
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

Map<String, Object?> get map2 => {
      k2: '2',
      k3: null,
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
        k9: 1,
        k10: [1, '2', null, false],
      },
    };

Map<String, Object?> get map3 => {
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
        k9: 1,
        k10: [
          1,
          2,
          3,
          {
            ListBehavior.name: ListBehavior.replaceWithNew.value,
          }
        ],
      },
    };

List<Object?> get list1 => [
      map1,
    ];

List<Object?> get list2 => [
      map2,
    ];
