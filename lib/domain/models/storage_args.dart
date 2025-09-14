import '../enums/storage_directory_options.dart';

/// Since FlutterStorage will be an async creation, you should pass
/// this parameter into a repository layer. Then you can create an async getter
/// that will initialize the object on the first call. It is worse to try and
/// create a async constructor and pass it into objects. Pass in the model args
/// and let the repo/bloc layer (which is async friendly) handle the storage object
///
/// EXAMPLE
///
/// class VishalRepo {
///   final StorageArgs args;
///
///   VishalRepo({required this.args});
///
///  IFileStorage? _storage;
///  Future<IFileStorage> storage(StorageArgs args) async {
///   if (_storage == null) {
///      _storage = await FlutterStorage.create(storageArgs: args);
///      return _storage!;
///    } else {
///      return _storage!;
///    }
///  }
/// }

class StorageArgs {
  final StorageDirectoryOptions dirLocation;
  final String folderName;

  StorageArgs({required this.dirLocation, required this.folderName});
}
