import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/auth/viewmodels/auth.viewmodel.dart';
import 'package:provider/provider.dart';

/// The page with a login form.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<AuthViewModel>(
        create: (context) => AuthViewModel(
          context: context,
        ),
        child: Consumer<AuthViewModel>(
          builder: (context, provider, child) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                /// Form width.
                child: SizedBox(
                  width: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Геоконтролируемые съёмки',
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      /// Login.
                      TextField(
                        decoration: const InputDecoration(hintText: 'Логин'),
                        controller: provider.loginController,
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      /// Password.
                      TextField(
                        controller: provider.passwordController,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          hintText: 'Пароль',

                          /// Display and hide the password.
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FilledButton.tonal(
                        onPressed: () {
                          provider.tryLogin();
                        },
                        child: const Text('Войти'),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                        future: provider.model,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            /// Ok.
                            if (snapshot.hasData) {
                              return const Text('');

                              /// Error.
                            } else if (snapshot.hasError) {
                              return Text(
                                '${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Colors.red,
                                    ),
                              );
                            }
                          }

                          /// Loading.
                          return const CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
