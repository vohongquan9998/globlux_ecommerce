import 'package:flutter/material.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color;
  const DefaultButton({Key key, this.text, this.press, this.color})
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
            topLeft: Radius.circular(25),
            bottomRight: Radius.circular(45),
            topRight: Radius.circular(25),
            bottomLeft: Radius.circular(45),
          ),
        ),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
