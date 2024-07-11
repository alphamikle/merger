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
