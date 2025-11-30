import 'package:dio/dio.dart';

/// Model for work with API.
class ApiModel {
  // Dio with default options.
  static final dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment('API_URL'),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Authorization': '',
      },
    ),
  );
}
