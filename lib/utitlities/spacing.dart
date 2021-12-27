
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_task/utitlities/size_config.dart';

class Spacing extends StatelessWidget {
  final double height;
  final double width;

  Spacing.height(this.height) : width = 0;

  Spacing.tinyHeight() : this.height(4);

  Spacing.smallHeight() : this.height(8);

  Spacing.mediumHeight() : this.height(16);

  Spacing.bigHeight() : this.height(26);
  Spacing.betweenCard() : this.height(28);
  Spacing.betweenCardFields() : this.height(12);

  Spacing.largeHeight() : this.height(32);
  Spacing.extraLargHeight() : this.height(getProportionateScreenHeight(80));

  Spacing.width(this.width) : height = 0;

  Spacing.tinyWidth() : this.width(4);

  Spacing.smallWidth() : this.width(8);

  Spacing.mediumWidth() : this.width(16);

  Spacing.bigWidth() : this.width(24);

  Spacing.largeWidth() : this.width(32);

  Spacing.empty()
      : width = 0,
        height = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }
}
