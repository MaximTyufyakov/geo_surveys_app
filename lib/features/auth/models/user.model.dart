import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:geo_surveys_app/common/models/api.model.dart';

/// A model with user data and logic.
class UserModel {
  /// Check login and password.
  ///
  /// Returns a [Future] that completes when the response is successful and
  /// correct login or password entry.
  /// Throws a [Future.error] with [String] message if database fails
  /// or incorrect login or password entry.
  static Future<UserModel> tryLogin(String login, String password) async {
    try {
      // Api response.
      Response<Map<String, String>> response = await ApiModel.dio.post(
        '/users/auth',
        data: {
          'login': login,
          'password': password,
        },
      );

      // Token create.
      if (response.statusCode == 201) {
        ApiModel.dio.options.headers['Authorization'] =
            'Bearer ${response.data!['token']}';
        return UserModel();

        // Unauthorized.
      } else if (response.statusCode == 401) {
        return Future.error('Неверный логин или пароль.');

        // Another error.
      } else {
        return Future.error('Ошибка при обращении к серверу.');
      }
    } on SocketException {
      return Future.error('Ошибка: нет соеденинения с базой данных.');
    } on TimeoutException {
      return Future.error(
          'Ошибка: время ожидания подключения к базе данных истекло.');
    } on TypeError {
      return Future.error(
          'Ошибка: из базы данных получен неправильный тип данных.');
    } catch (e) {
      return Future.error('Неизвестная ошибка при обращении к базе данных.');
    }
  }
}
