import 'list_merger.dart';
import 'settings.dart';
import 'tools.dart';

typedef ValueAction = void Function();

Map<K, V> mergeMaps<K extends Object, V extends Object?>(
  Map<K, V> recipient,
  Map<K, V> sender, {
  MergeStrategy strategy = MergeStrategy.addAndOverride,
  NullBehavior nullBehavior = NullBehavior.replace,
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
  ).merge(MergeSettings.fromJson(sender[MergeSettings.name]));

  sender.remove(MergeSettings.name);

  final MergeStrategy effectiveStrategy = settings.strategy ?? strategy;
  final NullBehavior effectiveNullBehavior = settings.nullBehavior ?? nullBehavior;
  final MapBehavior effectiveMapBehavior = settings.mapBehavior ?? mapBehavior;
  final ListBehavior effectiveListBehavior = settings.listBehavior ?? listBehavior;
  final ResultBehavior effectiveResultBehavior = settings.resultBehavior ?? resultBehavior;

  final Map<K, V> result = switch (effectiveResultBehavior) {
    ResultBehavior.returnNew => <K, V>{...recipient},
    ResultBehavior.mergeWithOld => recipient,
  };

  for (final MapEntry(key: key, value: value) in sender.entries) {
    if (isScalar(key) == false) {
      throw Exception('Keys of map can be only scalar type. Key "${key.toString()}" has wrong type "${key.runtimeType}"');
    }

    final Object? recipientValue = recipient[key];
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
      throw Exception('Unsupported mergeable type: (${value.runtimeType}) $value with key $key');
    }

    void handleNullValue() {
      final _ = switch (effectiveNullBehavior) {
        NullBehavior.replace => result[key] = valueToMerge as V,
        NullBehavior.doNothing => null,
        NullBehavior.remove => result.remove(key),
      };
    }

    late final ValueAction addOnly;
    late final ValueAction addAndOverride;
    late final ValueAction overrideOnly;

    addOnly = () {
      if (result.containsKey(key) == false) {
        if (valueToMerge == null) {
          handleNullValue();
        } else {
          if (recipientValue == null) {
            handleNullValue();
          }
          result[key] = valueToMerge as V;
        }
      } else if ((result[key] is Map && valueToMerge is Map) || (result[key] is List && valueToMerge is List)) {
        addAndOverride();
      }
    };

    addAndOverride = () {
      if (valueToMerge == null) {
        handleNullValue();
      } else {
        if (recipientValue == null) {
          handleNullValue();
        }
        result[key] = valueToMerge as V;
      }
    };

    overrideOnly = () {
      if (result.containsKey(key)) {
        if (valueToMerge == null) {
          handleNullValue();
        } else {
          if (recipientValue == null) {
            handleNullValue();
          }
          result[key] = valueToMerge as V;
        }
      }
    };

    final _ = switch (effectiveStrategy) {
      MergeStrategy.addOnly => addOnly(),
      MergeStrategy.addAndOverride => addAndOverride(),
      MergeStrategy.overrideOnly => overrideOnly(),
    };
  }

  return result;
}
