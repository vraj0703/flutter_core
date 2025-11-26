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
    HttpResponse? response;

    if (urlParams != null) {
      Map<String, String> params = {};
      urlParams.forEach((key, value) {
        params[key] = value.toString();
      });

      url += RestUtils.encodeParams(params);
    }

    switch (method) {
      case MethodType.get:
        response = await get(url, headers: headers);
        break;
      case MethodType.post:
        response = await _request(
          () => _client.post(
            Uri.parse(url),
            headers: headers,
            body: body,
            encoding: encoding,
          ),
        );
        break;
      case MethodType.put:
        response = await _request(
          () => _client.put(
            Uri.parse(url),
            headers: headers,
            body: body,
            encoding: encoding,
          ),
        );
        break;
      case MethodType.patch:
        response = await _request(
          () => _client.patch(
            Uri.parse(url),
            headers: headers,
            body: body,
            encoding: encoding,
          ),
        );
        break;
      case MethodType.delete:
        response = await _request(
          () => _client.delete(
            Uri.parse(url),
            headers: headers,
            body: body,
            encoding: encoding,
          ),
        );
        break;
      case MethodType.head:
        response = await _request(
          () => _client.head(Uri.parse(url), headers: headers),
        );
        break;
    }
    return response;
  }

  Future<HttpResponse> _request(HttpRequest request) async {
    http.Response response;
    try {
      response = await request();
    } on Exception catch (e) {
      dev.log('Network call failed: ${e.toString()}');
      response = http.Response('ERROR: Could not get a response', 404);
    }
    return HttpResponse(response);
  }
}

class HttpResponse {
  final http.Response? raw;

  NetErrorType? errorType;

  bool get success => errorType == NetErrorType.none;

  String? get body => raw?.body;

  Map<String, String>? get headers => raw?.headers;

  int get statusCode => raw?.statusCode ?? -1;

  HttpResponse(this.raw) {
    //No response at all, there must have been a connection error
    if (raw == null) {
      errorType = NetErrorType.disconnected;
    } else if (raw!.statusCode >= 200 && raw!.statusCode <= 299) {
      errorType = NetErrorType.none;
    } else if (raw!.statusCode >= 500 && raw!.statusCode < 600) {
      errorType = NetErrorType.timedOut;
    } else if (raw!.statusCode >= 400 && raw!.statusCode < 500) {
      errorType = NetErrorType.denied;
    }
  }
}

class ServiceResult<R> {
  final HttpResponse response;

  R? content;

  bool get parseError => content == null;

  bool get success => response.success && !parseError;

  ServiceResult(this.response, R Function(Map<String, dynamic>) parser) {
    if (StringUtils.isNotEmpty(response.body) && response.success) {
      try {
        content = parser.call(jsonDecode(utf8.decode(response.raw!.bodyBytes)));
      } on FormatException catch (e) {
        dev.log('ParseError: ${e.message}');
      }
    }
  }
}
