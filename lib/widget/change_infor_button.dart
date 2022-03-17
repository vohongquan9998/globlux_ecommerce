import 'package:flutter/material.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';

class ChangeInfoButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color;
  final IconData icon;
  const ChangeInfoButton(
      {Key key, this.text, this.press, this.color, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: FlatButton(
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(1),
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(1),
            bottomLeft: Radius.circular(25),
          ),
        ),
        onPressed: press,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            icon != null
                ? SizedBox(
                    width: SizeConfig.screenWidth * .02,
                  )
                : Container(),
            Icon(
              icon ?? Icons.no_cell,
              color: icon != null ? Colors.white : Colors.transparent,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
