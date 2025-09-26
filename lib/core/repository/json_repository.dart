import 'package:dart_either/dart_either.dart';

abstract class ILocalJsonRepository {
  Future<Either<Exception, String>> jsonStringFromLocal(String path);

  Future<Either<Exception, T>> executeGET<T>({
    required String jsonPath,
    required T Function(String) transformer,
    void Function(Exception)? onError,
  });
}
