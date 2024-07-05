import 'map_merger.dart';
import 'settings.dart';
import 'tools.dart';

List<V> mergeLists<V extends Object?>(
  List<V> recipient,
  List<V> sender, {
  MergeStrategy strategy = MergeStrategy.addAndOverride,
  NullBehavior nullBehavior = NullBehavior.doNothing,
  MapBehavior mapBehavior = MapBehavior.keyByKey,
  ListBehavior listBehavior = ListBehavior.valueByValue,
  ResultBehavior resultBehavior = ResultBehavior.returnNew,
}) {
  final MergeSettings settings = MergeSettings(
    strategy: strategy,
    nullBehavior: nullBehavior,
    mapBehavior: mapBehavior,
    listBehavior: listBehavior,
    resultBehavior: resultBehavior,
  ).merge(MergeSettings.fromJson(sender.lastOrNull));

  final MergeStrategy effectiveStrategy = settings.strategy ?? strategy;
  final NullBehavior effectiveNullBehavior = settings.nullBehavior ?? nullBehavior;
  final MapBehavior effectiveMapBehavior = settings.mapBehavior ?? mapBehavior;
  final ListBehavior effectiveListBehavior = settings.listBehavior ?? listBehavior;
  final ResultBehavior effectiveResultBehavior = settings.resultBehavior ?? resultBehavior;

  final List<V> result = switch (effectiveResultBehavior) {
    ResultBehavior.returnNew => <V>[...recipient],
    ResultBehavior.mergeWithOld => recipient,
  };

  final List<int> indexesForRemove = [];

  for (int i = 0; i < sender.length; i++) {
    final V value = sender[i];
    final Object? recipientValue = recipient.atIndex(i);
    final bool isRecValueMap = recipientValue is Map<Object, Object?>;
    final bool isRecValueList = recipientValue is List<Object?>;

    V? valueToMerge;

    if (isScalar(value)) {
      valueToMerge = value;
    } else if (value is Map<Object, Object?>) {
      final bool replaceWithNew = switch (effectiveMapBehavior) {
        MapBehavior.keyByKey => false,
        MapBehavior.replaceWithNew => true,
      };

      valueToMerge = mergeMaps(
        replaceWithNew ? <Object, Object?>{} : (isRecValueMap ? recipientValue : <Object, Object?>{}),
        value,
        strategy: effectiveStrategy,
        nullBehavior: effectiveNullBehavior,
        mapBehavior: effectiveMapBehavior,
        listBehavior: effectiveListBehavior,
        resultBehavior: effectiveResultBehavior,
      ) as V?;
    } else if (value is List<Object?>) {
      final bool replaceWithNew = switch (effectiveListBehavior) {
        ListBehavior.valueByValue => false,
        ListBehavior.replaceWithNew => true,
      };

      valueToMerge = mergeLists(
        replaceWithNew ? <Object?>[] : (isRecValueList ? recipientValue : <Object?>[]),
        value,
        strategy: effectiveStrategy,
        nullBehavior: effectiveNullBehavior,
        mapBehavior: effectiveMapBehavior,
        listBehavior: effectiveListBehavior,
        resultBehavior: effectiveResultBehavior,
      ) as V?;
    } else {
      throw Exception('Unsupported mergeable type: (${value.runtimeType}) $value with index $i');
    }

    void handleNullValue() {
      final _ = switch (effectiveNullBehavior) {
        NullBehavior.replace => result.insertAtOrAdd(i, valueToMerge as V),
        NullBehavior.doNothing => null,
        NullBehavior.remove => indexesForRemove.add(i),
      };
    }

    void addOnly() {
      if (result.hasIndex(i) == false) {
        if (valueToMerge == null) {
          handleNullValue();
        } else {
          result.add(valueToMerge as V);
        }
      }
    }

    void addAndOverride() {
      if (valueToMerge == null) {
        handleNullValue();
      } else {
        result.insertAtOrAdd(i, valueToMerge as V);
      }
    }

    void overrideOnly() {
      if (result.hasIndex(i)) {
        if (valueToMerge == null) {
          handleNullValue();
        } else {
          result[i] = valueToMerge as V;
        }
      }
    }

    final _ = switch (effectiveStrategy) {
      MergeStrategy.addOnly => addOnly(),
      MergeStrategy.addAndOverride => addAndOverride(),
      MergeStrategy.overrideOnly => overrideOnly(),
    };
  }

  for (int i = 0; i < indexesForRemove.length; i++) {
    final int index = indexesForRemove[i] - i;

    result.removeAt(index);
  }

  return result;
}
