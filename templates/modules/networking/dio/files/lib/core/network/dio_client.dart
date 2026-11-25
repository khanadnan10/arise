import 'package:dio/dio.dart';

/// Pre-configured HTTP client powered by Dio.
class DioClient {
  DioClient({
    String baseUrl = '',
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
  }) : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            headers: const {'Content-Type': 'application/json'},
          ),
        );

  final Dio dio;
}
