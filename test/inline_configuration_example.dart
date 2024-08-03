import 'package:merger/src/settings.dart';

import 'keys.dart';

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
            ListBehavior.name: ListBehavior.valueByValue, // (*) -> But, [donor.k6.k7.k2[2]] and all its descendents will have [ListBehavior.valueByValue]
            NullBehavior.name: NullBehavior.remove, // and also, [donor.k6.k7.k2[2]] and all its descendents will have [NullBehavior.remove]
            // and finally, [donor.k6.k7.k2[2]] still will have [MergeStrategy.addOnly]
          }
        ],
        [
          3,
          4,
        ],
      ],
      MergeSettings.name: {
        ListBehavior.name: ListBehavior.replaceWithNew, // [donor.k6.k7.k2] and all its descendents will have [ListBehavior.replaceWithNew] -> (*)
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
