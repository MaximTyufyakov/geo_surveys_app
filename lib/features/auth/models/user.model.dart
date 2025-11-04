import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bcrypt/bcrypt.dart';
import 'package:geo_surveys_app/common/models/databases.model.dart';
import 'package:postgres/postgres.dart';

/// A model with user data and logic.
///
/// The [userid] parameter is the user identifier.
/// The [login] parameter is the username.
class UserModel {
  UserModel({
    required this.userid,
    required this.login,
  });

  /// User identifier.
  int userid;

  /// Username.
  String login;

  /// Check login and password.
  ///
  /// Returns a [Future] that completes when the response is successful and
  /// correct login or password entry.
  /// Throws a [Future.error] with [String] message if database fails
  /// or incorrect login or password entry.
  static Future<UserModel> tryLogin(String login, String password) async {
    try {
      final conn = await Connection.open(
        GeosurveysDB.endpoint,
        settings: GeosurveysDB.settings,
      );

      Result response = await conn.execute(
        Sql.named(
          ''' SELECT userid, login, password
              FROM "user"
              WHERE login = @login;''',
        ),
        parameters: {
          'login': login,
        },
      );

      await conn.close();

      bool checkPassword = false;
      if (response.isNotEmpty) {
        checkPassword = BCrypt.checkpw(
          password,
          response[0][2] as String,
        );
      }

      if (checkPassword) {
        return UserModel(
          userid: response[0][0] as int,
          login: login,
        );
      } else {
        return Future.error('Неверный логин или пароль.');
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
      if (e is ServerException) {
        log(e.message);
        return Future.error('Ошибка: запрос к базе данных отклонён.');
      }
      return Future.error('Неизвестная ошибка при обращении к базе данных.');
    }
  }
}
