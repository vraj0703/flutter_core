/// This class is used to help simplify in-memory caching. Rather than roll a custom/manual implementation every time
/// we can simply extend this class. Using generics, you can define ID (your key type) and T (your value Type)
abstract class BaseCache<T, ID> {
  final Map<ID, T> _inMemoryCache = {};

  T? fetchById(ID id) {
    return _inMemoryCache[id];
  }

  void storeSingle(ID id, T item) {
    _inMemoryCache[id] = item;
  }

  void storeAll(List<T> items, ID Function(T) idProvider) {
    for (T item in items) {
      _inMemoryCache[idProvider(item)] = item;
    }
  }

  void clear() {
    _inMemoryCache.clear();
  }
}