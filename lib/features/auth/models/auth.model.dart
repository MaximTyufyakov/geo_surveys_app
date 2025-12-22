import 'dart:async';
import 'package:dio/dio.dart';
import 'package:geo_surveys_app/common/models/api.model.dart';

/// A model with Auth logic.
class AuthModel {
  /// Check login and password.
  ///
  /// Returns a [Future] that completes when the response is successful and
  /// correct login or password entry.
  /// Throws a [Future.error] with [String] message if database fails
  /// or incorrect login or password entry.
  static Future<AuthModel> tryLogin(String login, String password) async {
    try {
      /// Api response.
      final Response<Map<String, dynamic>> response = await dio.post(
        '/users/auth',
        data: {'login': login, 'password': password},
        options: Options(
          validateStatus: (status) => status == 201 || status == 401,
        ),
      );

      switch (response.statusCode) {
        /// Token create.
        case 201:
          dio.options.headers['Authorization'] =
              'Bearer ${response.data!['token']}';
          return AuthModel();

        /// Unauthorized.
        case 401:
          return Future.error('Неверный логин или пароль.');

        default:
          return Future.error('Ошибка при обращении к серверу.');
      }
    } on DioException {
      return Future.error('Ошибка при обращении к серверу.');
    }
  }

  void removeToken() {
    dio.options.headers['Authorization'] = '';
  }
}
