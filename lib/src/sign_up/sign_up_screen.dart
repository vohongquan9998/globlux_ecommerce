import 'package:flutter/material.dart';
import 'package:flutter_online_shop/exceptions/auth/firebase_exception.dart';
import 'package:flutter_online_shop/exceptions/auth/sign_up_exception.dart';
import 'package:flutter_online_shop/services/auth/auth_services.dart';
import 'package:flutter_online_shop/src/sign_in/sign_in_screen.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/circleContainer.dart';
import 'package:flutter_online_shop/widget/default_button.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

class SignUpScreen extends StatelessWidget {
  String dk =
      "Việc vi phạm chính sách này có thể dẫn tới một số hành động, bao gồm bất kỳ hoặc tất cả các hành động sau:\n-Xóa danh mục sản phẩm;\n-Giới hạn quyền sử dụng Tài Khoản;\n-Đình chỉ và chấm dứt Tài Khoản;\n-Thu hồi tiền/tài sản có được do hành vi gian lận, và các chi phí có liên quan như chi phí vận chuyển của đơn hàng, phí thanh toán…;\n-Cáo buộc hình sự;\n-Áp dụng biện pháp dân sự, bao gồm khiếu nại bồi thường thiệt hại và/hoặc áp dụng biện pháp khẩn cấp tạm thời;\n-Các hành động hoặc biện pháp chế tài khác theo Tiêu Chuẩn Cộng Đồng, Quy Chế Hoạt Động, hoặc các Chính Sách Globlux.\nNếu bạn phát hiện Người Sử Dụng trên Trang Globlux của chúng tôi có hành vi vi phạm Điều Khoản Dịch Vụ, vui lòng liên hệ chúng tôi.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          child: Stack(
            children: [
              Positioned(
                top:
                    getProportionateScreenHeight(SizeConfig.screenHeight * .03),
                left: getProportionateScreenWidth(SizeConfig.screenWidth * .1),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: .5,
                ),
              ),
              Positioned(
                top:
                    getProportionateScreenHeight(SizeConfig.screenHeight * .01),
                right:
                    getProportionateScreenWidth(SizeConfig.screenWidth * .14),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: .2,
                ),
              ),
              Positioned(
                top:
                    getProportionateScreenHeight(SizeConfig.screenHeight * .22),
                right:
                    -getProportionateScreenWidth(SizeConfig.screenWidth * .3),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: .6,
                ),
              ),
              Positioned(
                bottom: -getProportionateScreenHeight(
                    SizeConfig.screenHeight * .05),
                left:
                    -getProportionateScreenWidth(SizeConfig.screenWidth * .38),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: 1.2,
                ),
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      Text(
                        "Đăng kí".toUpperCase(),
                        style: headingStyle,
                      ),
                      Text(
                        "Điền đầy đủ thông tin để tiếp tục \ntạo tài khoản",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      SignUpForm(),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      Text(
                        "Việc xác nhận đăng kí tài khoản đồng nghĩa việc bạn\n chấp nhận các điều khoản của chúng tôi",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: getProportionateScreenHeight(5)),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Tôi Đã Hiểu'))
                                  ],
                                  scrollable: true,
                                  title: Text(
                                    "Điều khoản phần mềm Globlux",
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: Container(
                                      width: SizeConfig.screenWidth,
                                      child: Text(dk),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Text(
                          "Xem thêm về điều khoản >>",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: SizeConfig.screenWidth * 0.03),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                )),
                            child: Text(
                              'Đăng nhập',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  fontSize: getProportionateScreenWidth(20)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController confirmPasswordFieldController =
      TextEditingController();

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    confirmPasswordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding)),
        child: Column(
          children: [
            buildEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildConfirmPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(40)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(screenPadding * 2)),
              child: DefaultButton(
                text: "Đăng Kí Mới",
                press: signUpButtonCallback,
              ),
            ),
          ],
        ),
      ),
    );
  }

//Edit Text ConfirmPassword
  Widget buildConfirmPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordFieldController,
      obscureText: true,
      decoration: InputDecoration(
          labelText: "Confirm Password",
          hintText: 'Xác nhận mật khẩu',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
              topRight: Radius.circular(1),
              bottomLeft: Radius.circular(1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
              topRight: Radius.circular(1),
              bottomLeft: Radius.circular(1),
            ),
          ),
          labelStyle: TextStyle(color: Colors.black87),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefixIcon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          )),
      validator: (value) {
        // if (confirmPasswordFieldController.text.isEmpty) {
        //   return kPassNullError;
        // } else
        if (confirmPasswordFieldController.text !=
                passwordFieldController.text &&
            confirmPasswordFieldController.text.isNotEmpty) {
          return kMatchPassError;
        } else if (confirmPasswordFieldController.text.length < 8 &&
            confirmPasswordFieldController.text.isNotEmpty) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

//EditText Email
  Widget buildEmailFormField() {
    return TextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Tài khoản email',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(1),
            bottomLeft: Radius.circular(1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(1),
            bottomLeft: Radius.circular(1),
          ),
        ),
        labelStyle: TextStyle(color: Colors.black87),
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: Icon(
          Icons.mail,
          color: kPrimaryColor,
        ),
      ),
      validator: (value) {
        // if (emailFieldController.text.isEmpty) {
        //   return kEmailNullError;
        // } else
        if (!emailValidatorRegExp.hasMatch(emailFieldController.text) &&
            emailFieldController.text.isNotEmpty) {
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

//EditText Password
  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordFieldController,
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Mật khẩu',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
              topRight: Radius.circular(1),
              bottomLeft: Radius.circular(1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
              topRight: Radius.circular(1),
              bottomLeft: Radius.circular(1),
            ),
          ),
          labelStyle: TextStyle(color: Colors.black87),
          labelText: "Password",
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefixIcon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          )),
      validator: (value) {
        // if (passwordFieldController.text.isEmpty) {
        //   return kPassNullError;
        // } else
        if (passwordFieldController.text.length < 8 &&
            passwordFieldController.text.isNotEmpty) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signUpButtonCallback() async {
    if (_formKey.currentState.validate()) {
      // goto complete profile page
      final AuthentificationService authService = AuthentificationService();
      bool signUpStatus = false;
      String snackbarMessage;
      try {
        final signUpFuture = authService.signUp(
          email: emailFieldController.text,
          password: passwordFieldController.text,
        );
        signUpFuture.then((value) => signUpStatus = value);
        signUpStatus = await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              signUpFuture,
              message: Text("Hệ thống đang tạo tài khoản"),
            );
          },
        );
        if (signUpStatus == true) {
          snackbarMessage =
              "Tạo tài khoản thành công,bạn cần kích hoạt tài khoản để tiếp tục các chức năng";
        } else {
          throw FirebaseSignUpAuthUnknownReasonFailureException();
        }
      } on MessagedFirebaseAuthException catch (e) {
        snackbarMessage = e.message;
      } catch (e) {
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
        if (signUpStatus == true) {
          Navigator.pop(context);
        }
      }
    }
  }
}
