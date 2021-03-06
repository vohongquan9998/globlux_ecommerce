import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_shop/services/auth/auth_services.dart';
import 'package:flutter_online_shop/src/about/about_screen.dart';
import 'package:flutter_online_shop/src/change_infomation/change_email.dart';
import 'package:flutter_online_shop/src/change_infomation/change_name.dart';
import 'package:flutter_online_shop/src/change_infomation/change_password.dart';
import 'package:flutter_online_shop/src/edit_product/edit_product_screen.dart';
import 'package:flutter_online_shop/src/manager_address/manager_address_screen.dart';
import 'package:flutter_online_shop/src/orders/my_orders_screen.dart';
import 'package:flutter_online_shop/src/product/my_product_screen.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/utils/utils.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          StreamBuilder<User>(
              stream: AuthentificationService().userChanges,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  return buildUserAccountsHeader(user);
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: Icon(Icons.error),
                  );
                }
              }),
          buildEditAccountExpansionTile(context),
          ListTile(
            leading: Icon(
              Icons.edit_location,
              color: kPrimaryColor,
            ),
            title: Text(
              "?????a ch???",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onTap: () async {
              bool allowed = AuthentificationService().currentUserVerified;
              if (!allowed) {
                final reverify = await showConfirmationDialog(context,
                    "B???n ch??a x??c minh ?????a ch??? email c???a m??nh. H??nh ?????ng n??y ch??? ???????c ph??p ?????i v???i nh???ng ng?????i d??ng ???? x??c minh.",
                    positiveResponse: "G???i email x??c minh",
                    negativeResponse: "Tr??? v???");
                if (reverify) {
                  final future = AuthentificationService()
                      .sendVerificationEmailToCurrentUser();
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return FutureProgressDialog(
                        future,
                        message: Text(
                            "??ang ti???n h??nh g???i x??c minh.\nVui l??ng ?????i trong gi??y l??t"),
                      );
                    },
                  );
                }
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageAddressesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.grid_view,
              color: kPrimaryColor,
            ),
            title: Text(
              "????n ?????t h??ng",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onTap: () async {
              bool allowed = AuthentificationService().currentUserVerified;
              if (!allowed) {
                final reverify = await showConfirmationDialog(context,
                    "B???n ch??a x??c minh ?????a ch??? email c???a m??nh. H??nh ?????ng n??y ch??? ???????c ph??p ?????i v???i nh???ng ng?????i d??ng ???? x??c minh.",
                    positiveResponse: "G???i email x??c minh",
                    negativeResponse: "Tr??? v???");
                if (reverify) {
                  final future = AuthentificationService()
                      .sendVerificationEmailToCurrentUser();
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return FutureProgressDialog(
                        future,
                        message: Text(
                            "??ang ti???n h??nh g???i x??c minh.\nVui l??ng ?????i trong gi??y l??t"),
                      );
                    },
                  );
                }
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyOrdersScreen(),
                ),
              );
            },
          ),
          buildSellerExpansionTile(context),
          ListTile(
            leading: Icon(
              Icons.info,
              color: kPrimaryColor,
            ),
            title: Text(
              "About Us",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutDeveloperScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: kPrimaryColor,
            ),
            title: Text(
              "????ng xu???t",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onTap: () async {
              final confirmation = await showConfirmationDialog(
                  context, "B???n c?? ch???c mu???n ????ng xu???t kh??ng?");
              if (confirmation) AuthentificationService().signOut();
            },
          ),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader buildUserAccountsHeader(User user) {
    return UserAccountsDrawerHeader(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.5),
      ),
      accountEmail: Text(
        user.email ?? "No Email",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      accountName: Text(
        user.displayName ?? "Mr.No-Name",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
    );
  }

  ExpansionTile buildEditAccountExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: Icon(
        Icons.person,
        color: kPrimaryColor,
      ),
      title: Text(
        "Ch???nh s???a t??i kho???n",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(screenPadding * 1.5)),
          child: ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.title,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * .05,
                ),
                Text(
                  "Thay ?????i T??n",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeDisplayNameScreen(),
                  ));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(screenPadding * 1.6)),
          child: ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.mail_outline_sharp,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * .05,
                ),
                Text(
                  "Thay ?????i ?????a ch??? Email",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeEmailScreen(),
                  ));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(screenPadding * 1.6)),
          child: ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.lock_open,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * .05,
                ),
                Text(
                  "Thay ?????i m???t kh???u",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ));
            },
          ),
        ),
      ],
    );
  }

  Widget buildSellerExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: Icon(
        Icons.shop_two,
        color: kPrimaryColor,
      ),
      title: Text(
        "Ch??? ????? b??n h??ng",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(screenPadding * 1.6)),
          child: ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.add_business,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * .05,
                ),
                Text(
                  "Th??m s???n ph???m",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () async {
              bool allowed = AuthentificationService().currentUserVerified;
              if (!allowed) {
                final reverify = await showConfirmationDialog(context,
                    "B???n ch??a x??c minh ?????a ch??? email c???a m??nh. H??nh ?????ng n??y ch??? ???????c ph??p ?????i v???i nh???ng ng?????i d??ng ???? x??c minh.",
                    positiveResponse: "G???i email x??c minh",
                    negativeResponse: "Tr??? v???");
                if (reverify) {
                  final future = AuthentificationService()
                      .sendVerificationEmailToCurrentUser();
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return FutureProgressDialog(
                        future,
                        message: Text(
                            "??ang ti???n h??nh g???i x??c minh.\nVui l??ng ?????i trong gi??y l??t"),
                      );
                    },
                  );
                }
                return;
              }
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProductScreen()));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(screenPadding * 1.6)),
          child: ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.mode_edit,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * .05,
                ),
                Text(
                  "Qu???n l?? s???n ph???m",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () async {
              bool allowed = AuthentificationService().currentUserVerified;
              if (!allowed) {
                final reverify = await showConfirmationDialog(context,
                    "B???n ch??a x??c minh ?????a ch??? email c???a m??nh. H??nh ?????ng n??y ch??? ???????c ph??p ?????i v???i nh???ng ng?????i d??ng ???? x??c minh.",
                    positiveResponse: "G???i email x??c minh",
                    negativeResponse: "Tr??? v???");
                if (reverify) {
                  final future = AuthentificationService()
                      .sendVerificationEmailToCurrentUser();
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return FutureProgressDialog(
                        future,
                        message: Text(
                            "??ang ti???n h??nh g???i x??c minh.\nVui l??ng ?????i trong gi??y l??t"),
                      );
                    },
                  );
                }
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyProductsScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
