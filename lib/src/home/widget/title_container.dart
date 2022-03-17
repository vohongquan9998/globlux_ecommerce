import 'package:flutter/material.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';

class TitleContainer extends StatelessWidget {
  final String title;
  TitleContainer({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * .08,
      decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Center(
        child: Text(
          title.toUpperCase(),
          style: titleStyle,
        ),
      ),
    );
  }
}
