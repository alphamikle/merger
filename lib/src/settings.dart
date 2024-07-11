enum MergeStrategy {
  /// Will add new values by key or index only if the same key or index is not present in the recipient
  addOnly('MergeStrategy:addOnly'),

  /// Will replace old values with the new one, only if the same key or index is present in the recipient
  overrideOnly('MergeStrategy:overrideOnly'),

  /// Will replace and add new values by key or index in any way
  addAndOverride('MergeStrategy:addAndOverride');

  const MergeStrategy(this.value);

  static const String name = 'strategy';

  static MergeStrategy? fromValue(Object? value) {
    if (value is MergeStrategy) {
      return value;
    }

    return switch (value) {
      'MergeStrategy:addOnly' => MergeStrategy.addOnly,
      'MergeStrategy:overrideOnly' => MergeStrategy.overrideOnly,
      'MergeStrategy:addAndOverride' => MergeStrategy.addAndOverride,
      _ => null,
    };
  }

  final String value;
}

enum NullBehavior {
  /// If the new value is [null] then replace old value by key or index in recipient with explicit [null]
  replace('NullBehavior:replace'),

  /// If the new value is [null] - do nothing with the old value by that key or index in recipient
  /// Might be helpful within List<Object?> if you want to replace N-th item and don't know the values of 0...N items, just put [null] instead and they'll be the old one
  doNothing('NullBehavior:doNothing'),

  /// If the new value is [null] - remove that key or index from the recipient at all
  remove('NullBehavior:remove');

  const NullBehavior(this.value);

  static const String name = 'nullBehavior';

  static NullBehavior? fromValue(Object? value) {
    if (value is NullBehavior) {
      return value;
    }

    return switch (value) {
      'NullBehavior:replace' => NullBehavior.replace,
      'NullBehavior:doNothing' => NullBehavior.doNothing,
      'NullBehavior:remove' => NullBehavior.remove,
      _ => null,
    };
  }

  final String value;
}

enum MapBehavior {
  /// If the new value is [Map], and the old value by the same key in recipient is [Map] as well - totally replace old [Map] with new one
  /// Will have no effect with recipient [Map] itself, only with child [Map]s
  replaceWithNew('MapBehavior:replaceWithNew'),

  /// If both values is [Map]s, then replace every value by key in old [Map] of recipient with values by keys from the new [Map] value
  keyByKey('MapBehavior:keyByKey');

  const MapBehavior(this.value);

  static const String name = 'mapBehavior';

  static MapBehavior? fromValue(Object? value) {
    if (value is MapBehavior) {
      return value;
    }

    return switch (value) {
      'MapBehavior:replaceWithNew' => MapBehavior.replaceWithNew,
      'MapBehavior:keyByKey' => MapBehavior.keyByKey,
      _ => null,
    };
  }

  final String value;
}

enum ListBehavior {
  /// If the new value is [List] and the old value by the same key in recipient is [List] as well - totally replace old [List] with new one
  /// Will have no effect with recipient [List] itself, only with child [List]s
  replaceWithNew('ListBehavior:replaceWithNew'),

  /// If both values is [List]s, then replace every value by index in old [List] of recipient with values by indexes from the new [List] value
  valueByValue('ListBehavior:valueByValue');

  const ListBehavior(this.value);

  static const String name = 'listBehavior';

  static ListBehavior? fromValue(Object? value) {
    if (value is ListBehavior) {
      return value;
    }

    return switch (value) {
      'ListBehavior:replaceWithNew' => ListBehavior.replaceWithNew,
      'ListBehavior:valueByValue' => ListBehavior.valueByValue,
      _ => null,
    };
  }

  final String value;
}

enum ResultBehavior {
  /// Return totally new [Map] or [List] as a result of merge
  returnNew('ResultBehavior:returnNew'),

  /// Return changed recipient [Map] or [List] as a result of merge
  mergeWithOld('ResultBehavior:mergeWithOld');

  const ResultBehavior(this.value);

  static const String name = 'resultBehavior';

  static ResultBehavior? fromValue(Object? value) {
    if (value is ResultBehavior) {
      return value;
    }

    return switch (value) {
      'ResultBehavior:returnNew' => ResultBehavior.returnNew,
      'ResultBehavior:mergeWithOld' => ResultBehavior.mergeWithOld,
      _ => null,
    };
  }

  final String value;
}

class MergeSettings {
  const MergeSettings({
    this.strategy,
    this.nullBehavior,
    this.mapBehavior,
    this.listBehavior,
    this.resultBehavior,
  });

  factory MergeSettings.fromJson(Object? json) {
    if (json is! Map) {
      return const MergeSettings();
    }

    return MergeSettings(
      strategy: MergeStrategy.fromValue(json[MergeStrategy.name]),
      nullBehavior: NullBehavior.fromValue(json[NullBehavior.name]),
      mapBehavior: MapBehavior.fromValue(json[MapBehavior.name]),
      listBehavior: ListBehavior.fromValue(json[ListBehavior.name]),
      resultBehavior: ResultBehavior.fromValue(json[ResultBehavior.name]),
    );
  }

  static const String name = 'MergeSettings:';

  MergeSettings merge(MergeSettings other) {
    return MergeSettings(
      strategy: other.strategy ?? strategy,
      nullBehavior: other.nullBehavior ?? nullBehavior,
      mapBehavior: other.mapBehavior ?? mapBehavior,
      listBehavior: other.listBehavior ?? listBehavior,
      resultBehavior: other.resultBehavior ?? resultBehavior,
    );
  }

  final MergeStrategy? strategy;
  final NullBehavior? nullBehavior;
  final MapBehavior? mapBehavior;
  final ListBehavior? listBehavior;
  final ResultBehavior? resultBehavior;

  bool get isEmpty => strategy == null && nullBehavior == null && mapBehavior == null && listBehavior == null && resultBehavior == null;

  bool get isNotEmpty => isEmpty == false;
}
