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

class ChangePasswordScreen extends StatelessWidget {
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
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.05),
                      ChangePasswordForm(),
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

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  bool isVisible = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding * 2)),
        child: Column(
          children: [
            TitleContainer(
              title: 'Thay Đổi mật khẩu',
            ),
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(screenPadding * 2),
                      top: getProportionateScreenHeight(screenPadding),
                      bottom: getProportionateScreenHeight(screenPadding)),
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryColor, width: 2),
                    color: Colors.grey[200].withOpacity(.9),
                  ),
                  child: Column(
                    children: [
                      buildCurrentPasswordFormField(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildNewPasswordFormField(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildConfirmNewPasswordFormField(),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: 10,
                    height: SizeConfig.screenHeight * .37,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            ChangeInfoButton(
              text: "Đổi mật khẩu".toUpperCase(),
              icon: Icons.check,
              press: () {
                final updateFuture = changePasswordButtonCallback();
                showDialog(
                  context: context,
                  builder: (context) {
                    return FutureProgressDialog(
                      updateFuture,
                      message: Text("Đang cập nhật Mật khẩu"),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmNewPasswordFormField() {
    return TextFormField(
      controller: confirmNewPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Xác nhận mật khẩu",
        labelText: "Xác nhận mật khẩu",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: isVisible
        //     ? GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             isVisible = !isVisible;
        //           });
        //         },
        //         child: Icon(Icons.visibility))
        //     : GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             isVisible = !isVisible;
        //           });
        //         },
        //         child: Icon(Icons.visibility_off)),
      ),
      validator: (value) {
        if (confirmNewPasswordController.text != newPasswordController.text) {
          return "Mật khẩu không trùng khớp";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentPasswordFormField() {
    return TextFormField(
      controller: currentPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập mật khẩu hiện tại",
        labelText: "Mật khẩu hiện tại",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        return null;
      },
      autovalidateMode: AutovalidateMode.disabled,
    );
  }

  Widget buildNewPasswordFormField() {
    return TextFormField(
      controller: newPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nhập mật khẩu mới",
        labelText: "Mật khẩu mới",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (newPasswordController.text.isEmpty) {
          return "Mật khẩu không thể để trống";
        } else if (newPasswordController.text.length < 8) {
          return "Mật khẩu quá ngắn";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> changePasswordButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final AuthentificationService authService = AuthentificationService();
      bool currentPasswordValidation = await authService
          .verifyCurrentUserPassword(currentPasswordController.text);
      if (currentPasswordValidation == false) {
        print("Current password provided is wrong");
      } else {
        bool updationStatus = false;
        String snackbarMessage;
        try {
          updationStatus = await authService.changePasswordForCurrentUser(
              newPassword: newPasswordController.text);
          if (updationStatus == true) {
            snackbarMessage = "Cập nhật mật khẩu thành công";
          } else {
            throw FirebaseCredentialActionAuthUnknownReasonFailureException(
                message: "Thay đổi mật khẩu thất bại,vui lòng thử lại sau");
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
