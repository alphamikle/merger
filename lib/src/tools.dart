typedef SettingsExtractor<S, V> = S? Function(V? object);
typedef ObjectList = List<Object?>;

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

  void replaceAtOrAdd(int index, T value) {
    if (hasIndex(index)) {
      this[index] = value;
    } else {
      add(value);
    }
  }
}
