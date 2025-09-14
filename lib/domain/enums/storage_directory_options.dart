/// There are only 2 options - CACHE or DOCUMENT DIRECTORY
///
/// CACHE - this is the equivalent as NSCacheDirectory (iOS) & getCacheDir (Android)
/// the CACHE directory can be cleared by the application at any time
///
/// DOCUMENT - this is NSDocumentDirectory (iOS) and AppData (Android). This can only
/// be cleared when the application is deleted
enum StorageDirectoryOptions { cache, document }
