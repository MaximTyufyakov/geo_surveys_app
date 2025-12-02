import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/auth/models/user.model.dart';

/// A ViewModel of the auth page.
///
/// The [context] parameter is the context of the auth page.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required this.openTasksPage,
  });

  /// CallBack from page.
  final VoidCallback openTasksPage;

  /// Controller for login.
  final loginController = TextEditingController();

  /// Controller for password.
  final passwordController = TextEditingController();

  /// User model.
  Future<UserModel> model = Future.value(UserModel());

  /// Check login and password.
  void tryLogin() async {
    /// Empty check.
    if (loginController.text.isEmpty || passwordController.text.isEmpty) {
      model = Future.error('Введите логин и пароль.');
    } else {
      // Login and password check.
      model = UserModel.tryLogin(
        loginController.text,
        passwordController.text,
      );
    }

    notifyListeners();

    /// Ok.
    await model.then(
      (value) async {
        /// Reset password and login
        loginController.text = '';
        passwordController.text = '';

        /// Open new page.
        openTasksPage();
      },
    ).catchError((err) {});
  }
}
