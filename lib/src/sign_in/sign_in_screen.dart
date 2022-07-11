import 'package:flutter/material.dart';
import 'package:flutter_online_shop/exceptions/auth/firebase_exception.dart';
import 'package:flutter_online_shop/exceptions/auth/sign_in_exception.dart';
import 'package:flutter_online_shop/services/auth/auth_services.dart';
import 'package:flutter_online_shop/src/forgot_password/forgot_password_screen.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/circleContainer.dart';
import 'package:flutter_online_shop/widget/default_button.dart';
import 'package:flutter_online_shop/widget/no_acc_text.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: SizeConfig.screenHeight,
          child: Stack(
            children: [
              Positioned(
                top: -getProportionateScreenHeight(
                    SizeConfig.screenHeight * .07),
                left: getProportionateScreenWidth(SizeConfig.screenWidth * .1),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: .5,
                ),
              ),
              Positioned(
                top:
                    getProportionateScreenHeight(SizeConfig.screenHeight * .12),
                right:
                    getProportionateScreenWidth(SizeConfig.screenWidth * .14),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: .2,
                ),
              ),
              Positioned(
                bottom:
                    getProportionateScreenHeight(SizeConfig.screenHeight * .22),
                left: -getProportionateScreenWidth(SizeConfig.screenWidth * .3),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: .8,
                ),
              ),
              Positioned(
                bottom: -getProportionateScreenHeight(
                    SizeConfig.screenHeight * .22),
                right:
                    -getProportionateScreenWidth(SizeConfig.screenWidth * .6),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: 1.2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(screenPadding)),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.04),
                      Text(
                        "Globlux".toUpperCase(),
                        style: headingStyle,
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      Text(
                        'Mua sắm \t-\t Tin cậy \t-\t Hiện đại',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.06),
                      SignInForm(),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      NoAccountText(),
                      SizedBox(height: getProportionateScreenHeight(20)),
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

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: buildPasswordFormField()),
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ));
                },
                child: Text(
                  "Quên \n mật khẩu",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          // buildForgotPasswordWidget(context),
          // SizedBox(height: getProportionateScreenHeight(30)),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding * 2)),
            child: DefaultButton(
              text: "Đăng nhập",
              press: signInButtonCallback,
            ),
          ),
        ],
      ),
    );
  }

  // Row buildForgotPasswordWidget(BuildContext context) {
  //   return Row(
  //     children: [
  //       Spacer(),
  //       GestureDetector(
  //         onTap: () {
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => ForgotPasswordScreen(),
  //               ));
  //         },
  //         child: Text(
  //           "Quên mật khẩu",
  //           style: TextStyle(
  //             color: kPrimaryColor,
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordFieldController,
      obscureText: true,
      decoration: InputDecoration(
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
        labelText: "Password",
        hintText: 'Mật khẩu',
        labelStyle: TextStyle(color: Colors.black87),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: Icon(
          Icons.lock,
          color: kPrimaryColor,
        ),
      ),
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

  Widget buildEmailFormField() {
    return TextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
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
          hintText: 'Tài khoản email',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefixIcon: Icon(
            Icons.mail,
            color: kPrimaryColor,
          )),
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

  Future<void> signInButtonCallback() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      final AuthentificationService authService = AuthentificationService();
      bool signInStatus = false;
      String snackbarMessage;
      try {
        final signInFuture = authService.signIn(
          email: emailFieldController.text.trim(),
          password: passwordFieldController.text.trim(),
        );
        signInFuture.then((value) => signInStatus = value);
        signInStatus = await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              signInFuture,
              message: Text("Đang đăng nhập vào tài khoản"),
            );
          },
        );
        if (signInStatus == true) {
          snackbarMessage = "Đăng nhập thành công";
        } else {
          throw FirebaseSignInAuthUnknownReasonFailure();
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
      }
    }
  }
}
