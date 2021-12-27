import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
  //screenWidth;
}

// Get the proportionate height as per screen size
double getProportionateScreenHeightForFont(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 375 is the layout width that designer use
  //using 375 so the font comes out fitting actual
  //device width
  return (inputHeight / 375.0) * screenHeight;
}

double getProportionatefontSize(double fontSize) {
  if (SizeConfig.orientation == Orientation.portrait) {
    return getProportionateScreenWidth(fontSize);
  }
  return getProportionateScreenHeightForFont(fontSize);
}

double getProportionateAdjustedfontSize(double fontSize) {
  if (SizeConfig.orientation == Orientation.portrait &&
      SizeConfig.screenWidth > 590) {
    double tempSize = fontSize / 3;
    fontSize = tempSize * 2;
  }
  if (SizeConfig.orientation == Orientation.portrait) {
    return getProportionateScreenWidth(fontSize);
  }
  return getProportionateScreenHeightForFont(fontSize);
}
