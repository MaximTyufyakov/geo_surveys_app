import 'package:bcrypt/bcrypt.dart';
import 'package:geo_surveys_app/common/models/db.model.dart';
import 'package:postgres_dart/postgres_dart.dart';

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
      if (DbModel.geosurveysDb.db.isClosed) {
        await DbModel.geosurveysDb.open();
      }
      DbResponse response = await DbModel.geosurveysDb.table('user').select(
        columns: [
          Column('userid'),
          Column('login'),
          Column('password'),
        ],
        where: Where(
          'login',
          WhereOperator.isEqual,
          login,
        ),
      );
      bool checkPassword = false;
      if (response.data.isNotEmpty) {
        checkPassword = BCrypt.checkpw(
          password,
          response.data[0][2] as String,
        );
      }
      if (checkPassword) {
        return UserModel(
          userid: response.data[0][0] as int,
          login: login,
        );
      } else {
        return Future.error('Неверный логин или пароль.');
      }
    } catch (e) {
      return Future.error('Ошибка при обращении к базе данных.');
    }
  }
}
