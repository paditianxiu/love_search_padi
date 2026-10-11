import 'package:dio/dio.dart';

import '../models/json_value.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
            ));

  Future<T> getJson<T>(
    String url, {
    required T Function(Object? json) fromJson,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<Object?>(
      url,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: Options(responseType: ResponseType.plain),
    );
    return fromJson(decodeJson(response.data));
  }

  Future<String> getText(String url, {CancelToken? cancelToken}) async {
    final response = await _dio.get<String>(
      url,
      cancelToken: cancelToken,
      options: Options(responseType: ResponseType.plain),
    );
    return response.data ?? '';
  }
}
