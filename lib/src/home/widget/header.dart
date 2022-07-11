import 'package:flutter/material.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/widget/icon_button_counter.dart';
import 'package:flutter_online_shop/widget/round_icon_button.dart';
import 'package:flutter_online_shop/widget/search_text_field.dart';

class HomeHeader extends StatelessWidget {
  final Function onSearchSubmitted;
  final Function onCartButtonPressed;
  const HomeHeader({
    Key key,
    @required this.onSearchSubmitted,
    @required this.onCartButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RoundedIconButton(
            iconData: Icons.menu,
            press: () {
              Scaffold.of(context).openDrawer();
            }),
        Expanded(
          child: SearchField(
            onSubmit: onSearchSubmitted,
          ),
        ),
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(.4), shape: BoxShape.circle),
          child: IconButtonWithCounter(
            svgSrc: "assets/icons/Cart Icon.svg",
            numOfItems: 0,
            press: onCartButtonPressed,
          ),
        ),
      ],
    );
  }
}
