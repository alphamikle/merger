import 'package:merger/src/map_merger.dart';
import 'package:merger/src/settings.dart';
import 'package:test/test.dart';

import 'examples.dart';

void main() {
  test('Flat Map with flat Map', () {
    final Map<String, Object?> result = mergeMaps(flat1, flat2);

    expect(result, {
      'field1': '1',
      'field2': '2',
      'field3': 3,
      'field4': '4',
      'field5': false,
    });
  });

  test('Complex Map with complex Map', () {
    final Map<String, Object?> result = mergeMaps(cx1, cx2);

    expect(result, {
      'field1': {
        'field2': 2,
        'field3': false,
        'field10': true,
      },
      'field4': '4',
      'field5': 5.0,
      'field6': {
        'field7': {
          'field8': 8,
        },
        'field9': {
          'field11': 11,
        },
      },
    });
  });

  test('Map with Lists vs Map with Lists', () {
    final Map<String, Object?> result = mergeMaps(
      withList1,
      withList2,
      nullBehavior: NullBehavior.doNothing,
    );

    expect(result, {
      'field1': '2',
      'field2': ['1', 2, 4],
      'field3': {
        'field4': {
          4: 5,
        },
        'field5': {
          'field6': [
            {
              'field7': '7',
              'field8': ['8', 9, 10.5],
            },
            11,
            '12',
            [false, 14, true],
          ],
        }
      },
      'field9': [
        {1: 2, 3: 4},
        17,
        18
      ],
    });
  });
}
