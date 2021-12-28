import 'package:flutter/material.dart';
import 'package:mvvm_task/constants/styles.dart';

SnackBar customSnackBar({required String content}) {
  return SnackBar(
    content: Text(
      content,
      style: AppStyles.bodyText1,
    ),
  );
}

customDialog(BuildContext context, TextEditingController _smsCodeController,
    Function buttonClicked) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text(
              "Enter Verification Code",
              style: AppStyles.heading2,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _smsCodeController,
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    buttonClicked();
                  },
                  child: const Text(
                    "Done",
                    style: AppStyles.bodyText1,
                  ))
            ],
          ));
}
