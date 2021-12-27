import 'package:flutter/material.dart';
import 'package:mvvm_task/constants/colors.dart';
import 'package:mvvm_task/utitlities/size_config.dart';

SizedBox continueButton(
    Function clicked, double spaceBeforeIcon, String buttonText) {
  return SizedBox(
    height: getProportionateScreenHeight(52),
    width: getProportionateScreenWidth(302),
    child: ElevatedButton(
      onPressed: () {
        clicked();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonText,
            style: const TextStyle(
                color: AppColors.onPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: spaceBeforeIcon,
          ),
          const Icon(
            Icons.arrow_forward,
            color: AppColors.black,
          )
        ],
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => AppColors.primaryColor),
          shape: MaterialStateProperty.resolveWith((states) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}
