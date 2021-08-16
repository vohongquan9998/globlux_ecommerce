import 'package:flutter/material.dart';
import 'package:flutter_online_shop/src/sign_up/sign_up_screen.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(
        //   "",
        //   style: TextStyle(
        //     fontSize: getProportionateScreenWidth(16),
        //   ),
        // ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: Text(
            "Đăng kí ngay",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              fontWeight: FontWeight.w800,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
