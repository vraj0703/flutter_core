import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_core/domain/typedef/typedef.dart';
import 'package:http/http.dart' as http;

abstract class RestApiClient {
  Future<String> get(String endpoint);

  Future<http.Response> post(String endpoint, Map<String, dynamic>? body);

  Future<http.Response> postObject(Object? body, String endpoint);

  Future<http.Response> put({
    required String endpoint,
    String? contentType,
    String? body,
    bool forceRefresh = false,
  });

  Future<http.Response> putMap(String endpoint, Map<String, dynamic>? body);

  Future<String> multiPartRequest({
    required File fileToUpload,
    required String endpoint,
    OnUploadProgressCallback? uploadCallback,
    String? fileMediaType,
    String fileFieldName = 'file',
  });

  Future<http.Response> delete(String endpoint);

  Future<Uint8List> downloadFile(String endpoint);
}
