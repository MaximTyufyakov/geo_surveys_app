import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/auth/models/user.model.dart';

/// A ViewModel of the auth page.
///
/// The [context] parameter is the context of the auth page.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required this.context,
  });

  /// Context of the auth page.
  final BuildContext context;

  /// Controller for login.
  final loginController = TextEditingController();

  /// Controller for password.
  final passwordController = TextEditingController();

  /// User model.
  late Future<UserModel> model = Future.value(UserModel(
    login: '',
    userid: 0,
  ));

  /// Check login and password.
  void tryLogin() async {
    /// Database query and check.
    model = UserModel.tryLogin(
      loginController.text,
      passwordController.text,
    );

    notifyListeners();

    await model.then(
      (value) async {
        if (context.mounted) {
          /// Reset password and login
          loginController.text = '';
          passwordController.text = '';

          /// Open new page.
          await Navigator.pushNamed(
            context,
            '/tasks',
            arguments: {
              'userid': value.userid,
            },
          );
        }
      },
    ).catchError((err) {});
  }
}
