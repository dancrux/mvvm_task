
import 'package:flutter/material.dart';
import 'package:mvvm_task/view/auth/login.dart';
import 'package:mvvm_task/view/home/home.dart';
import 'package:mvvm_task/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';


class BaseWidgetScreen extends StatelessWidget {
  const BaseWidgetScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Consumer(builder: (context, AuthViewModel user, _) {
        switch (user.authStatus) {
          case AuthStatus.unauthenticated:
            return const LoginScreen();

          case AuthStatus.authenticated:
            return const HomeScreen();
          case AuthStatus.authenticating:
            return const LoginScreen();

          default:
            return const LoginScreen();
        }
      }),
    );
  }
}