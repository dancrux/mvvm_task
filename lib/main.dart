import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_task/view/app.dart';
import 'package:mvvm_task/viewmodels/auth_viewmodel.dart';
import 'package:mvvm_task/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await Firebase.initializeApp();
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
            create: (context) => AuthViewModel.instance()),
        ChangeNotifierProvider<HomeViewModel>(
            create: (context) => HomeViewModel()),
      ],
      child: const App(),
    ));
  });
}
