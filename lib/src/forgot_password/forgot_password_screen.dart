import 'package:flutter/material.dart';
import 'package:flutter_online_shop/exceptions/auth/actions_exception.dart';
import 'package:flutter_online_shop/exceptions/auth/firebase_exception.dart';
import 'package:flutter_online_shop/services/auth/auth_services.dart';
import 'package:flutter_online_shop/src/sign_in/sign_in_screen.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/circleContainer.dart';
import 'package:flutter_online_shop/widget/default_button.dart';
import 'package:flutter_online_shop/widget/no_acc_text.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String routeName = "/forgot_password";
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
                top: getProportionateScreenHeight(SizeConfig.screenHeight * .3),
                right:
                    getProportionateScreenWidth(SizeConfig.screenWidth * .05),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: .4,
                ),
              ),
              Positioned(
                bottom:
                    getProportionateScreenHeight(SizeConfig.screenHeight * .05),
                left: getProportionateScreenWidth(SizeConfig.screenWidth * .0),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: .4,
                ),
              ),
              Positioned(
                top:
                    getProportionateScreenHeight(SizeConfig.screenHeight * .01),
                left: -getProportionateScreenWidth(SizeConfig.screenWidth * .2),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: .8,
                ),
              ),
              Positioned(
                bottom:
                    getProportionateScreenHeight(SizeConfig.screenHeight * .1),
                right:
                    -getProportionateScreenWidth(SizeConfig.screenWidth * .05),
                child: CircleContainer(
                  color: kCircleContainer,
                  sizeRate: .75,
                ),
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(screenPadding)),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.04),
                        Text(
                          "Quên mật khẩu?",
                          textAlign: TextAlign.center,
                          style: headingStyle,
                        ),
                        Text(
                          "Đừng lo lắng,hãy cho chúng tôi biết email của bạn,chúng tôi sẽ giúp bạn phục hồi tài khoản",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.1),
                        ForgotPasswordForm(),
                      ],
                    ),
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

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  @override
  void dispose() {
    emailFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding * 2)),
            child: DefaultButton(
              text: "Gửi email xác minh",
              press: sendVerificationEmailButtonCallback,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          NoAccountText(),
          SizedBox(height: getProportionateScreenHeight(30)),
          backToSignIn(),
        ],
      ),
    );
  }

  Widget backToSignIn() {
    return Row(
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
            'Trở về',
            style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                fontSize: getProportionateScreenWidth(15)),
          ),
        ),
      ],
    );
  }

  TextFormField buildEmailFormField() {
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
        if (value.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> sendVerificationEmailButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final String emailInput = emailFieldController.text.trim();
      bool resultStatus;
      String snackbarMessage;
      try {
        final resultFuture =
            AuthentificationService().resetPasswordForEmail(emailInput);
        resultFuture.then((value) => resultStatus = value);
        resultStatus = await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              resultFuture,
              message: Text("Đang tiến hành gửi email xác thực"),
            );
          },
        );
        if (resultStatus == true) {
          snackbarMessage = "Đã gửi đường dẫn khôi phục mật khẩu";
        } else {
          throw FirebaseCredentialActionAuthUnknownReasonFailureException(
              message: "Thao tác thất bại,vui lòng thử lại");
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
