import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_shop/exceptions/auth/actions_exception.dart';
import 'package:flutter_online_shop/exceptions/auth/firebase_exception.dart';
import 'package:flutter_online_shop/services/auth/auth_services.dart';
import 'package:flutter_online_shop/src/home/widget/title_container.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/change_infor_button.dart';
import 'package:flutter_online_shop/widget/custom_stuffix_icon.dart';
import 'package:flutter_online_shop/widget/default_button.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

class ChangeEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          child: Stack(
            children: [
              // Positioned(
              //   top: 0,
              //   right: -SizeConfig.screenWidth * .4,
              //   child: Container(
              //     height: SizeConfig.screenHeight / 1.3,
              //     width: SizeConfig.screenWidth,
              //     decoration: BoxDecoration(
              //         color: kPrimaryColor.withOpacity(.3),
              //         borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(64),
              //             bottomLeft: Radius.circular(64))),
              //   ),
              // ),
              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   child: Container(
              //     height: SizeConfig.screenHeight / 2.1,
              //     width: SizeConfig.screenWidth / 2.5,
              //     decoration: BoxDecoration(
              //         color: kPrimaryColor.withOpacity(.4),
              //         borderRadius:
              //             BorderRadius.only(topLeft: Radius.circular(64))),
              //   ),
              // ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(0)),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.05),
                        ChangeEmailForm(),
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

class ChangeEmailForm extends StatefulWidget {
  @override
  _ChangeEmailFormState createState() => _ChangeEmailFormState();
}

class _ChangeEmailFormState extends State<ChangeEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    currentEmailController.dispose();
    newEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding * 2)),
        child: Column(
          children: [
            TitleContainer(
              title: "Thay đổi Địa chỉ Email",
            ),
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(screenPadding * 2),
                      top: getProportionateScreenHeight(screenPadding),
                      bottom: getProportionateScreenHeight(screenPadding)),
                  decoration: BoxDecoration(
                    color: Colors.grey[200].withOpacity(.9),
                    border: Border.all(color: kPrimaryColor, width: 2),
                  ),
                  child: Column(
                    children: [
                      buildCurrentEmailFormField(),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      buildNewEmailFormField(),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      buildPasswordFormField(),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: 10,
                    height: SizeConfig.screenHeight * .34,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            ChangeInfoButton(
              text: "Cập nhật Email".toUpperCase(),
              icon: Icons.check,
              press: () {
                final updateFuture = changeEmailButtonCallback();
                showDialog(
                  context: context,
                  builder: (context) {
                    return FutureProgressDialog(
                      updateFuture,
                      message: Text("Đang cập nhật Email"),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );

    return form;
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập Mật khẩu của bạn",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (passwordController.text.isEmpty) {
          return "Mật khẩu không được bỏ trống";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentEmailFormField() {
    return StreamBuilder<User>(
      stream: AuthentificationService().userChanges,
      builder: (context, snapshot) {
        String currentEmail;
        if (snapshot.hasData && snapshot.data != null)
          currentEmail = snapshot.data.email;
        final textField = TextFormField(
          controller: currentEmailController,
          decoration: InputDecoration(
            enabledBorder: outlineTextField,
            focusedBorder: outlineTextField,
            hintText: "Email hiện tại",
            labelText: "Email hiện tại",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          readOnly: true,
        );
        if (currentEmail != null) currentEmailController.text = currentEmail;
        return textField;
      },
    );
  }

  Widget buildNewEmailFormField() {
    return TextFormField(
      controller: newEmailController,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập Email muốn thay đổi",
        labelText: "Email mới",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (newEmailController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(newEmailController.text)) {
          return kInvalidEmailError;
        } else if (newEmailController.text == currentEmailController.text) {
          return "Email đã được liên kết";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> changeEmailButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final AuthentificationService authService = AuthentificationService();
      bool passwordValidation =
          await authService.verifyCurrentUserPassword(passwordController.text);
      if (passwordValidation) {
        bool updationStatus = false;
        String snackbarMessage;
        try {
          updationStatus = await authService.changeEmailForCurrentUser(
              newEmail: newEmailController.text);
          if (updationStatus == true) {
            snackbarMessage =
                "Gửi email xác minh. Vui lòng xác minh email mới của bạn";
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
}
