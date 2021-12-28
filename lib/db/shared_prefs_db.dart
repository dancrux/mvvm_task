import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtil {
  Future saveEmail(String email) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString('userEmail', email);
  }

  Future getEmail(String email) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('userEmail');
  }
}
