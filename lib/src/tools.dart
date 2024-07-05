import 'settings.dart';

typedef SettingsExtractor<S, V> = S? Function(V? object);
typedef ObjectList = List<Object?>;

bool isScalar(Object? value) {
  return value == null || value is int || value is double || value is String || value is bool;
}

extension ExtendedList<T> on List<T> {
  bool hasIndex(int index) {
    return length > index;
  }

  T? atIndex(int index) {
    if (hasIndex(index)) {
      return this[index];
    }
    return null;
  }

  void insertAtOrAdd(int index, T value) {
    if (hasIndex(index)) {
      this[index] = value;
    } else {
      add(value);
    }
  }
}

S? _fromListExtractor<S, V extends ObjectList>(V list) {
  if (list.isEmpty) {
    return null;
  }
  if (list.last is S) {
    return null;
  }
}

extension SettingsExtractorFromList<T> on List<T> {}
