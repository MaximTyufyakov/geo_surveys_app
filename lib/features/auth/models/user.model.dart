import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      PostgresDb geosurveysDb = PostgresDb(
        host: dotenv.env['DB_HOST'] as String,
        databaseName: dotenv.env['DB_NAME'] as String,
        username: dotenv.env['DB_USERNAME'] as String,
        password: dotenv.env['DB_PASSWORD'] as String,
        queryTimeoutInSeconds:
            int.parse(dotenv.env['DB_QUERY_TIMEOUT'] as String),
        timeoutInSeconds: int.parse(dotenv.env['DB_TIMEOUT'] as String),
      );
      if (geosurveysDb.db.isClosed) {
        await geosurveysDb.open();
      }
      DbResponse response = await geosurveysDb.table('user').select(
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
