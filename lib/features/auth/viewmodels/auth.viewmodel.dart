import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/auth/models/auth.model.dart';

/// A ViewModel of the auth page.
///
/// The [context] parameter is the context of the auth page.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required this.openTasksPage});

  /// CallBack from page.
  final ValueGetter<Future<void>> openTasksPage;

  /// Controller for login.
  final loginController = TextEditingController();

  /// Controller for password.
  final passwordController = TextEditingController();

  /// Auth model.
  Future<AuthModel> model = Future.value(AuthModel());

  /// Check login and password.
  Future<void> tryLogin() async {
    /// Empty check.
    model = loginController.text.isEmpty || passwordController.text.isEmpty
        ? Future.error('Введите логин и пароль.')
        : AuthModel.tryLogin(loginController.text, passwordController.text);

    notifyListeners();

    /// Ok.
    await model
        .then((value) async {
          /// Reset password and login
          loginController.text = '';
          passwordController.text = '';

          /// Open new page.
          await openTasksPage();
          // Clear token.
          await model.then((value) {
            value.removeToken();
          });
        })
        .catchError((err) {});
  }
}
