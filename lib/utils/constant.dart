import 'package:flutter/material.dart';
import 'package:flutter_online_shop/utils/size_config.dart';

const String appName = "Globlux";

Color kPrimaryColor = Colors.lightGreen[800];
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Colors.black87;

const kAnimationDuration = Duration(milliseconds: 200);
final kCircleContainer = Colors.lightGreen[100];

const double screenPadding = 10;

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(40),
  fontWeight: FontWeight.bold,
  color: Colors.teal[800],
  fontFamily: 'Roboto',
  letterSpacing: 1.5,
  height: 1.5,
);

final titleStyle = TextStyle(
  fontSize: getProportionateScreenWidth(20),
  fontWeight: FontWeight.bold,
  color: Colors.white70,
  height: 1.5,
);

final outlineTextField = OutlineInputBorder(
  borderSide: BorderSide(color: kPrimaryColor),
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(25),
    bottomRight: Radius.circular(0),
    topRight: Radius.circular(0),
    bottomLeft: Radius.circular(25),
  ),
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Vui lòng nhập Email";
const String kInvalidEmailError = "Vui lòng nhập Email hợp lệ";
const String kPassNullError = "Vui lòng nhập mật khẩu";
const String kShortPassError = "Mật khẩu quá ngắn";
const String kMatchPassError = "Mật khẩu không trùng khớp";
const String kNamelNullError = "Vui lòng nhập tên của bạn";
const String kPhoneNumberNullError = "Vui lòng nhập số điện thoại";
const String kAddressNullError = "Vui lòng nhập địa chỉ";
const String FIELD_REQUIRED_MSG = "Bắt buộc";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
