import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:geo_surveys_app/common/models/api.model.dart';

/// A model with user data and logic.
///
/// The [userid] parameter is the user identifier.
/// The [login] parameter is the username.
class UserModel {
  /// Check login and password.
  ///
  /// Returns a [Future] that completes when the response is successful and
  /// correct login or password entry.
  /// Throws a [Future.error] with [String] message if database fails
  /// or incorrect login or password entry.
  static Future<UserModel> tryLogin(String login, String password) async {
    try {
      Response<Map<String, String>> response = await ApiModel.dio.post(
        '/users/auth',
        data: {
          'login': login,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        ApiModel.dio.options.headers['Authorization'] =
            'Bearer ${response.data!['token']}';
        return UserModel();
      } else if (response.statusCode == 401) {
        return Future.error('Неверный логин или пароль.');
      } else {
        return Future.error('Ошибка при обращении к серверу.');
      }
    } on SocketException {
      return Future.error('Ошибка: нет соеденинения с базой данных.');
    }
  }
}
