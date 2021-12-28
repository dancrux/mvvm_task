import 'package:flutter/material.dart';
import 'package:mvvm_task/constants/styles.dart';
import 'package:mvvm_task/db/shared_prefs_db.dart';
import 'package:mvvm_task/network/repository.dart';
import 'package:mvvm_task/utitlities/spacing.dart';

class HomeScreen extends StatelessWidget {
  final String userEmail;
  HomeScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Repository repository = Repository();
    SharedPrefsUtil sharedPrefsUtil = SharedPrefsUtil();
    sharedPrefsUtil.saveEmail(userEmail);
    String greeting() {
      var currentTime = DateTime.now().hour;
      if (currentTime <= 12) {
        return 'Good Morning';
      } else if ((currentTime > 12) && (currentTime <= 16)) {
        return 'Good Afternoon';
      } else if ((currentTime > 16) && (currentTime < 20)) {
        return 'Good Evening';
      } else {
        return 'Good Night';
      }
    }

    String greetingMessage = greeting();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.mediumHeight(),
              Text(
                greetingMessage,
                style: AppStyles.heading2,
              ),
              Spacing.smallHeight(),
              FutureBuilder(
                  future: sharedPrefsUtil.getEmail('userEmail'),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.hasData ? snapshot.data.toString() : userEmail,
                      style: AppStyles.heading1,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
