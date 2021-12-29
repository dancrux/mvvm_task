import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_task/constants/strings.dart';
import 'package:mvvm_task/db/shared_prefs_db.dart';
import 'package:mvvm_task/view/auth/login.dart';
import 'package:mvvm_task/view/base_widget_screen.dart';
import 'package:mvvm_task/view/home/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: _theme(),
      onGenerateRoute: _routeFactory(),
      home: const BaseWidgetScreen(),
    );
  }
}

RouteFactory _routeFactory() {
  var authIntance = FirebaseAuth.instance;
  var email = authIntance.currentUser?.email;
  return (settings) {
    Widget screen;
    switch (settings.name) {
      case AppStrings.loginRoute:
        screen = const LoginScreen();
        break;

      case AppStrings.homeRoute:
        screen = HomeScreen(
          userEmail: email ?? SharedPrefsUtil.instance.getEmail(),
        );

        break;

      default:
        return null;
    }
    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}

ThemeData _theme() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.black),
        color: Colors.transparent,
        elevation: 0),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.blue,
  );
}
