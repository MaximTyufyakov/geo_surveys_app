import 'package:flutter/foundation.dart';
import 'package:geo_surveys_app/common/api.dart';
import 'package:geo_surveys_app/features/auth/controllers/auth.repository.dart';

/// A provider of the auth page.
class AuthProvider extends ChangeNotifier {
  AuthProvider({required this.openTasksPage});

  /// Auth repository.
  final AuthRepository _repository = AuthRepository();

  /// CallBack from page.
  final ValueGetter<Future<void>> openTasksPage;

  /// Login message.
  Future<String> message = Future.value('');

  /// Check input and login in api.
  Future<void> login({required String login, required String password}) async {
    /// Check password and login before request.
    message = _validate(login: login, password: password);
    notifyListeners();
    await message
        /// Valid.
        .then((valid) async {
          /// Login request.
          message = _repository.auth(login: login, password: password);
          notifyListeners();
          await message
              /// Ok.
              .then((token) async {
                /// Token.
                saveToken(token);

                /// Open new page.
                await openTasksPage();
              })
              /// Error.
              .catchError((Object err) {
                if (kDebugMode) {
                  debugPrint('Ошибка аутентификации: $err');
                }
              });
        })
        /// Not valid.
        .catchError((Object err) {
          if (kDebugMode) {
            debugPrint('Ошибка аутентификации: $err');
          }
        });
  }

  /// Check password and login.
  ///
  /// Returns [Future] value if valid.
  ///
  /// Throws a [Future.error] with [String] message if not valid.
  Future<String> _validate({
    required String login,
    required String password,
  }) async {
    /// Empty check.
    if (login.isEmpty || password.isEmpty) {
      return Future.error('Введите логин и пароль.');
    }
    return 'Успешно.';
  }
}
