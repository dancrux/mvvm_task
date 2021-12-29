import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtil {
  SharedPrefsUtil._privateConstructor();

  static final SharedPrefsUtil instance = SharedPrefsUtil._privateConstructor();

  static const String _userEmail = 'userEmail';
  saveEmail(String email) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(_userEmail, email);
    print("Prefs Stuff $email");
  }

  getEmail() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_userEmail);
  }
}
