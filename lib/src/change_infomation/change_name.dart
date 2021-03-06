import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_shop/services/auth/auth_services.dart';
import 'package:flutter_online_shop/src/home/widget/title_container.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/change_infor_button.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class ChangeDisplayNameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Container(
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
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.05),
                    ChangeDisplayNameForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeDisplayNameForm extends StatefulWidget {
  const ChangeDisplayNameForm({
    Key key,
  }) : super(key: key);

  @override
  _ChangeDisplayNameFormState createState() => _ChangeDisplayNameFormState();
}

class _ChangeDisplayNameFormState extends State<ChangeDisplayNameForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController newDisplayNameController =
      TextEditingController();

  final TextEditingController currentDisplayNameController =
      TextEditingController();

  @override
  void dispose() {
    newDisplayNameController.dispose();
    currentDisplayNameController.dispose();
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
              title: '?????i t??n',
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
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      buildCurrentDisplayNameField(),
                      SizedBox(height: SizeConfig.screenHeight * 0.05),
                      buildNewDisplayNameField(),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
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
              text: "C???p nh???t T??n".toUpperCase(),
              icon: Icons.check,
              press: () {
                final uploadFuture = changeDisplayNameButtonCallback();
                showDialog(
                  context: context,
                  builder: (context) {
                    return FutureProgressDialog(
                      uploadFuture,
                      message: Text("H??? th???ng ??ang c???p nh???t t??n ng?????i d??ng"),
                    );
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("C???p nh???t t??n ng?????i d??ng th??nh c??ng")));
              },
            ),
          ],
        ),
      ),
    );

    return form;
  }

  Widget buildNewDisplayNameField() {
    return TextFormField(
      controller: newDisplayNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        enabledBorder: outlineTextField,
        focusedBorder: outlineTextField,
        hintText: "Nh???p t??n b???n mu???n thay ?????i",
        labelText: "T??n m???i",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (newDisplayNameController.text.isEmpty) {
          return "Vui l??ng nh???p t??n ????? th???c hi???n c???p nh???t";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentDisplayNameField() {
    return StreamBuilder<User>(
      stream: AuthentificationService().userChanges,
      builder: (context, snapshot) {
        String displayName;
        if (snapshot.hasData && snapshot.data != null)
          displayName = snapshot.data.displayName;
        final textField = TextFormField(
          controller: currentDisplayNameController,
          decoration: InputDecoration(
            enabledBorder: outlineTextField,
            focusedBorder: outlineTextField,
            labelText: "T??n hi???n t???i",
            hintText: 'Kh??ng c?? t??n n??o t???n t???i',
            labelStyle: TextStyle(color: Colors.black87),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          readOnly: true,
        );
        if (displayName != null)
          currentDisplayNameController.text = displayName;
        return textField;
      },
    );
  }

  Future<void> changeDisplayNameButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await AuthentificationService()
          .updateCurrentUserDisplayName(newDisplayNameController.text);
      print("Display Name updated to ${newDisplayNameController.text} ...");
    }
  }
}
