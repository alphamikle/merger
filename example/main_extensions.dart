import 'package:merger/merger.dart';

import 'deep_equals.dart';
import 'main.dart' as m;

void main() {
  final List<Object?> recipientList = [m.recipient];
  final List<Object?> senderList = [m.sender];

  final List<Object?> resultList = recipientList.mergeWith(senderList);

  final Map<Object, Object?> resultMap = m.recipient.mergeWith(m.sender);
}
