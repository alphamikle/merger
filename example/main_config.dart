import 'package:merger/merger.dart';

import 'main.dart' as m;

void main() {
  final resultMap = m.recipient.mergeWith(
    m.sender,
    strategy: MergeStrategy.addAndOverride,
    resultBehavior: ResultBehavior.returnNew,
    listBehavior: ListBehavior.replaceWithNew,
    mapBehavior: MapBehavior.replaceWithNew,
    nullBehavior: NullBehavior.doNothing,
  );

  final resultList = [m.recipient].mergeWith(
    [m.sender],
    strategy: MergeStrategy.addAndOverride,
    resultBehavior: ResultBehavior.returnNew,
    listBehavior: ListBehavior.replaceWithNew,
    mapBehavior: MapBehavior.replaceWithNew,
    nullBehavior: NullBehavior.doNothing,
  );
}
