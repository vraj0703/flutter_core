/// During a READ operation, if the file does not exist, then throw this
/// exception so we can handle fetching it from backend potentially
class FileNotFound implements Exception {
  String path;
  FileNotFound(this.path);
}
