import 'dart:io';
import 'dart:typed_data';

import 'package:dart_either/dart_either.dart';
import 'package:flutter_core/domain/typedef/typedef.dart';
import 'package:flutter_core/domain/network/gql_client.dart';
import 'package:flutter_core/domain/network/rest_api_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

abstract class BaseRepository<R> {
  final RestApiClient _apiClient;
  final GQLClient _gqlClient;
  final Logger _logger;

  Future<Either<Exception, T>> get<T>({
    required String endpoint,
    required T Function(String) transformer,
    void Function(Exception)? onError,
  }) async {
    try {
      var response = await _apiClient.get(endpoint);
      return Right(transformer(response));
    } on Exception catch (e) {
      if (onError != null) {
        onError(e);
      }
      _logger.e('error with GET request: $e \n endpoint: $endpoint');
      return Left(e);
    } catch (error) {
      _logger.e('error with GET request: $error \n endpoint: $endpoint');
      return Left(Exception(error));
    }
  }

  Future<Either<Exception, T>> post<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    required T Function(http.Response) transformer,
    void Function(Exception)? onError,
  }) async {
    try {
      var response = await _apiClient.post(endpoint, body);
      return Right(transformer(response));
    } on Exception catch (e) {
      if (onError != null) {
        onError(e);
      }
      _logger.e('error with POST request: $e \n endpoint: $endpoint');
      return Left(e);
    } catch (error) {
      _logger.e('error with POST request: $error \n endpoint: $endpoint');
      return Left(Exception(error));
    }
  }

  Future<Either<Exception, T>> postWithBody<T>({
    required String endpoint,
    Object? body,
    required T Function(http.Response) transformer,
    void Function(Exception)? onError,
  }) async {
    try {
      var response = await _apiClient.postObject(body, endpoint);
      return Right(transformer(response));
    } on Exception catch (e) {
      if (onError != null) {
        onError(e);
      }
      _logger.e('error with POST Object request: $e \n endpoint: $endpoint');
      return Left(e);
    } catch (error) {
      _logger.e(
        'error with POST Object request: $error \n endpoint: $endpoint',
      );
      return Left(Exception(error));
    }
  }

  Future<Either<Exception, T>> put<T>({
    required String endpoint,
    String? contentType,
    String? body,
    bool forceRefresh = false,
    required T Function(http.Response) transformer,
    void Function(Exception)? onError,
  }) async {
    try {
      var response = await _apiClient.put(
        endpoint: endpoint,
        contentType: contentType,
        body: body,
        forceRefresh: forceRefresh,
      );
      return Right(transformer(response));
    } on Exception catch (e) {
      if (onError != null) {
        onError(e);
      }
      _logger.e('error with PUT request: $e \n endpoint: $endpoint');
      return Left(e);
    } catch (error) {
      _logger.e('error with PUT request: $error \n endpoint: $endpoint');
      return Left(Exception(error));
    }
  }

  Future<Either<Exception, T>> putMap<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    required T Function(http.Response) transformer,
    void Function(Exception)? onError,
  }) async {
    try {
      var response = await _apiClient.putMap(endpoint, body);
      return Right(transformer(response));
    } on Exception catch (e) {
      if (onError != null) {
        onError(e);
      }
      _logger.e('error with PUT request: $e \n endpoint: $endpoint');
      return Left(e);
    } catch (error) {
      _logger.e('error with PUT request: $error \n endpoint: $endpoint');
      return Left(Exception(error));
    }
  }

  Future<Either<Exception, T>> query<T>({
    required QueryOptions<Query> query,
    required T Function(Map<String, dynamic>) transformer,
    void Function(Exception)? onError,
  }) async {
    try {
      var response = await _gqlClient.query(query);
      return Right(transformer(response));
    } on Exception catch (e) {
      if (onError != null) {
        onError(e);
      }
      _logger.e('error with GQL query: $e \n query: ${query.asRequest}');
      return Left(e);
    }
  }

  Future<Either<Exception, T>> mutation<T>({
    required MutationOptions<Mutation> mutation,
    required T Function(Map<String, dynamic>?) transformer,
    void Function(Exception)? onError,
  }) async {
    try {
      var response = await _gqlClient.mutation(mutation);
      return Right(transformer(response));
    } on Exception catch (e) {
      if (onError != null) {
        onError(e);
      }
      _logger.e(
        'error with GQL mutation: $e \n mutation: ${mutation.asRequest}',
      );
      return Left(e);
    }
  }

  Future<Either<Exception, T>> multipartUpload<T>({
    required File fileToUpload,
    required String endpoint,
    required T Function(String) transformer,
    OnUploadProgressCallback? uploadCallback,
    String? fileMediaType,
    String fileFieldName = 'file',
    void Function(Exception)? onError,
  }) async {
    try {
      final response = await _apiClient.multiPartRequest(
        fileToUpload: fileToUpload,
        fileMediaType: fileMediaType,
        endpoint: endpoint,
        uploadCallback: uploadCallback,
        fileFieldName: fileFieldName,
      );
      return Right(transformer(response));
    } on Exception catch (e) {
      if (onError != null) {
        onError(e);
      }
      _logger.e('error with Multipart POST request: $e \n endpoint: $endpoint');
      return Left(e);
    }
  }

  Future<Either<Exception, T>> delete<T>({
    required String endpoint,
    required T Function(http.Response) transformer,
    void Function(Exception)? onError,
  }) async {
    try {
      var response = await _apiClient.delete(endpoint);
      return Right(transformer(response));
    } on Exception catch (e) {
      if (onError != null) {
        onError(e);
      }
      _logger.e('error with DELETE request: $e \n endpoint: $endpoint');
      return Left(e);
    } catch (error) {
      _logger.e('error with DELETE request: $error \n endpoint: $endpoint');
      return Left(Exception(error));
    }
  }

  Future<Either<Exception, T>> downloadFile<T>({
    required String endpoint,
    required T Function(Uint8List) transformer,
    void Function(Exception)? onError,
  }) async {
    try {
      var response = await _apiClient.downloadFile(endpoint);
      return Right(transformer(response));
    } on Exception catch (e) {
      if (onError != null) {
        onError(e);
      }
      _logger.e(
        'error with GET File download request: $e \n endpoint: $endpoint',
      );
      return Left(e);
    } catch (error) {
      _logger.e(
        'error with GET File download request: $error \n endpoint: $endpoint',
      );
      return Left(Exception(error));
    }
  }

  // helper method to verify POST/PUTs that require no transformation
  bool isValidHTTP(int code) => code >= 200 && code < 300;

  BaseRepository({
    required RestApiClient apiClient,
    required GQLClient gqlClient,
  }) : _logger = Logger(),
       _gqlClient = gqlClient,
       _apiClient = apiClient,
       super();
}
