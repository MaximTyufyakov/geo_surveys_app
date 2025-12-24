import 'package:dio/dio.dart';

/// Dio with default options.
final dio = Dio(
  BaseOptions(
    // Ignored for set base URL from env.
    // ignore: avoid_redundant_argument_values
    baseUrl: const String.fromEnvironment('API_URL'),
    connectTimeout: const Duration(seconds: 10),

    headers: {'Authorization': ''},
  ),
);

/// Save global token.
void saveToken(String token) {
  dio.options.headers['Authorization'] = 'Bearer $token';
}

/// Remove global token.
void clearToken() {
  dio.options.headers['Authorization'] = '';
}
