import 'package:dart_either/dart_either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

abstract class ILocalJsonRepository {
  Future<Either<Exception, String>> jsonStringFromLocal(String path);

  Future<Either<Exception, T>> executeGET<T>({
    required String jsonPath,
    required T Function(String) transformer,
    void Function(Exception)? onError,
  });
}

class LocalJsonRepository extends ILocalJsonRepository {
  LocalJsonRepository();

  @override
  Future<Either<Exception, String>> jsonStringFromLocal(String path) async {
    try {
      return Right(await rootBundle.loadString(path));
    } on FlutterError catch (e) {
      return Left(Exception(e.message));
    }
  }

  @override
  Future<Either<Exception, T>> executeGET<T>({
    required String jsonPath,

    required T Function(String) transformer,

    void Function(Exception)? onError,
  }) async {
    try {
      var response = await rootBundle.loadString(jsonPath);

      return Right(transformer(response));
    } on Exception catch (e) {
      if (onError != null) {
        onError(e);
      }

      return Left(e);
    } catch (error) {
      return Left(Exception(error.toString()));
    }
  }
}
