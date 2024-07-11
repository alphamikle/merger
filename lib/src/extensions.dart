import 'list_merger.dart';
import 'map_merger.dart';
import 'settings.dart';

extension MergeableMap<K extends Object, V extends Object?> on Map<K, V> {
  Map<K, V> mergeWith(
    Map<K, V> other, {
    MergeStrategy strategy = MergeStrategy.addAndOverride,
    NullBehavior nullBehavior = NullBehavior.replace,
    MapBehavior mapBehavior = MapBehavior.keyByKey,
    ListBehavior listBehavior = ListBehavior.valueByValue,
    ResultBehavior resultBehavior = ResultBehavior.returnNew,
  }) {
    return mergeMaps<K, V>(this, other);
  }
}

extension MergeableList<V extends Object?> on List<V> {
  List<V> mergeWith(
    List<V> other, {
    MergeStrategy strategy = MergeStrategy.addAndOverride,
    NullBehavior nullBehavior = NullBehavior.doNothing,
    MapBehavior mapBehavior = MapBehavior.keyByKey,
    ListBehavior listBehavior = ListBehavior.valueByValue,
    ResultBehavior resultBehavior = ResultBehavior.returnNew,
  }) {
    return mergeLists(this, other);
  }
}
