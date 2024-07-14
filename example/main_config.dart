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
