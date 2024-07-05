const Map<String, String> flat1 = {
  'field1': '1',
  'field2': '2',
  'field3': '3',
};

const Map<String, Object> flat2 = {
  'field3': 3,
  'field4': '4',
  'field5': false,
};

const Map<String, Object> cx1 = {
  'field1': {
    'field2': 2,
    'field3': false,
  },
  'field4': '4',
  'field5': 5.0,
  'field6': {
    'field7': {
      'field8': '8',
    },
    'field9': 9,
  },
};

const Map<String, Object> cx2 = {
  'field1': {
    'field10': true,
  },
  'field6': {
    'field7': {
      'field8': 8,
    },
    'field9': {
      'field11': 11,
    },
  },
};

const Map<String, Object> withList1 = {
  'field1': '1',
  'field2': [1, 2, 3],
  'field3': {
    'field4': 4,
    'field5': {
      'field6': [
        {
          'field7': '7',
          'field8': [8, 9, 10.5],
        },
        11,
        '12',
        [13, 14, '15'],
      ],
    }
  },
  'field9': [16, 17, 18],
};

const Map<String, Object> withList2 = {
  'field1': '2',
  'field2': ['1', null, 4],
  'field3': {
    'field4': {
      4: 5,
    },
    'field5': {
      'field6': [
        {
          'field7': null,
          'field8': ['8', null, 10.5],
        },
        11,
        null,
        [false, null, true],
      ],
    },
  },
  'field9': [
    {1: 2, 3: 4},
    17,
  ],
};
