import 'package:flutter/material.dart';
import 'package:flutter_online_shop/utils/size_config.dart';

class CircleContainer extends StatelessWidget {
  final double sizeRate;
  final Color color;

  CircleContainer({this.color, this.sizeRate});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * sizeRate,
      height: SizeConfig.screenWidth * sizeRate,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
