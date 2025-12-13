import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;

import '../network/rest_utils.dart';
import '../extensions/string_utils.dart';

enum NetErrorType { none, disconnected, timedOut, denied }

enum MethodType { get, post, put, patch, delete, head }

typedef HttpRequest = Future<http.Response> Function();

abstract class IHttpClient {
  Future<HttpResponse> get(String url, {Map<String, String>? headers});

  Future<HttpResponse> send(
    String url, {
    Map<String, dynamic>? urlParams,
    MethodType method = MethodType.get,
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
  });
}

class HttpClient implements IHttpClient {
  final http.Client _client;

  HttpClient({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<HttpResponse> get(String url, {Map<String, String>? headers}) async {
    return await _request(() async {
      return await _client.get(Uri.parse(url), headers: headers);
    });
  }

  @override
  Future<HttpResponse> send(
    String url, {
    Map<String, dynamic>? urlParams,
    MethodType method = MethodType.get,
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
  }) async {
    // Process URL Params
    if (urlParams != null && urlParams.isNotEmpty) {
      final Map<String, String> params = urlParams.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      url += RestUtils.encodeParams(params);
    }

    final uri = Uri.parse(url);

    // NOTE: Refactored switch to be more readable and direct
    switch (method) {
      case MethodType.get:
        return _request(() => _client.get(uri, headers: headers));
      case MethodType.post:
        return _request(
          () => _client.post(
            uri,
            headers: headers,
            body: body,
            encoding: encoding,
          ),
        );
      case MethodType.put:
        return _request(
          () => _client.put(
            uri,
            headers: headers,
            body: body,
            encoding: encoding,
          ),
        );
      case MethodType.patch:
        return _request(
          () => _client.patch(
            uri,
            headers: headers,
            body: body,
            encoding: encoding,
          ),
        );
      case MethodType.delete:
        return _request(
          () => _client.delete(
            uri,
            headers: headers,
            body: body,
            encoding: encoding,
          ),
        );
      case MethodType.head:
        return _request(() => _client.head(uri, headers: headers));
    }
  }

  Future<HttpResponse> _request(HttpRequest request) async {
    try {
      final response = await request();
      return HttpResponse(response);
    } on Exception catch (e) {
      dev.log('Network call failed: ${e.toString()}');
      return HttpResponse(
        null,
      ); // Return empty response which triggers disconnected/error type
    }
  }
}

class HttpResponse {
  final http.Response? raw;
  late final NetErrorType errorType;

  bool get success => errorType == NetErrorType.none;

  String? get body => raw?.body;

  Map<String, String>? get headers => raw?.headers;

  int get statusCode => raw?.statusCode ?? -1;

  HttpResponse(this.raw) {
    if (raw == null) {
      errorType = NetErrorType.disconnected;
    } else {
      final code = raw!.statusCode;
      if (code >= 200 && code < 300) {
        errorType = NetErrorType.none;
      } else if (code >= 500) {
        errorType = NetErrorType
            .timedOut; // Server errors treated as timeout/unavailable
      } else if (code >= 400) {
        errorType = NetErrorType.denied; // Client errors
      } else {
        errorType = NetErrorType.denied; // Fallback for other codes
      }
    }
  }
}

class ServiceResult<R> {
  final HttpResponse response;
  R? content;

  bool get parseError => content == null;
  bool get success => response.success && !parseError;

  ServiceResult(this.response, R Function(Map<String, dynamic>) parser) {
    if (response.success && StringUtils.isNotEmpty(response.body)) {
      try {
        final decoded = jsonDecode(utf8.decode(response.raw!.bodyBytes));
        if (decoded is Map<String, dynamic>) {
          content = parser(decoded);
        } else {
          dev.log(
            'ParseError: Expected Map<String, dynamic> but got ${decoded.runtimeType}',
          );
        }
      } on Exception catch (e) {
        dev.log('ParseError: ${e.toString()}');
      }
    }
  }
}
