import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_task/view/app.dart';
import 'package:mvvm_task/viewmodels/auth_viewmodel.dart';
import 'package:mvvm_task/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
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
