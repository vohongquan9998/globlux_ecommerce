import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_shop/services/db/user_db_helper.dart';
import 'package:flutter_online_shop/services/steams/address_stream.dart';
import 'package:flutter_online_shop/src/edit_address/edit_adress_screen.dart';
import 'package:flutter_online_shop/src/manager_address/widget/address_box.dart';
import 'package:flutter_online_shop/src/manager_address/widget/address_short_details_card.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/default_button.dart';
import 'package:flutter_online_shop/widget/nothing_show.dart';
import 'package:logger/logger.dart';

class ManageAddressesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ManagerAddressBody(),
    );
  }
}

class ManagerAddressBody extends StatefulWidget {
  @override
  _ManagerAddressBodyState createState() => _ManagerAddressBodyState();
}

class _ManagerAddressBodyState extends State<ManagerAddressBody> {
  final AddressesStream addressesStream = AddressesStream();

  @override
  void initState() {
    super.initState();
    addressesStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    addressesStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: SizeConfig.screenHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(screenPadding)),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Container(
                      width: SizeConfig.screenWidth * .9,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(SizeConfig.screenWidth * .01),
                      child: Row(
                        children: [
                          Icon(
                            Icons.help,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth * .03,
                          ),
                          Text(
                            "Vuốt sang TRÁI để CHỈNH SỬA - Vuốt sang PHẢI để XOÁ"
                                .toUpperCase(),
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth * .025,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    DefaultButton(
                      text: "Thêm địa chỉ mới",
                      press: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAddressScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.7,
                      child: StreamBuilder<List<String>>(
                        stream: addressesStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final addresses = snapshot.data;
                            if (addresses.length == 0) {
                              return Center(
                                child: NothingToShowContainer(
                                  iconPath: "assets/icons/add_location.svg",
                                  secondaryMessage: "Thêm địa chỉ đầu tiên",
                                ),
                              );
                            }
                            return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: addresses.length,
                                itemBuilder: (context, index) {
                                  return buildAddressItemCard(addresses[index]);
                                });
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            final error = snapshot.error;
                            Logger().w(error.toString());
                          }
                          return Center(
                            child: NothingToShowContainer(
                              iconPath: "assets/icons/network_error.svg",
                              primaryMessage: "Something went wrong",
                              secondaryMessage: "Unable to connect to Database",
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    addressesStream.reload();
    return Future<void>.value();
  }

  Future<bool> deleteButtonCallback(
      BuildContext context, String addressId) async {
    final confirmDeletion = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thông boá"),
          content: Text("Bạn có chắc xoá địa chỉ này không?"),
          actions: [
            FlatButton(
              child: Text("Có"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text("Không"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
    if (confirmDeletion) {
      bool status = false;
      String snackbarMessage;
      try {
        status =
            await UserDatabaseHelper().deleteAddressForCurrentUser(addressId);
        if (status == true) {
          snackbarMessage = "Xoá địa chỉ thành công";
        } else {
          throw "Thao tác thất bại,vui lòng thử lại";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = "Thao tác thất bại,vui lòng thử lại";
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
      await refreshPage();
      return status;
    }
    return false;
  }

  Future<bool> editButtonCallback(
      BuildContext context, String addressId) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditAddressScreen(addressIdToEdit: addressId)));
    await refreshPage();
    return false;
  }

  Future<void> addressItemTapCallback(String addressId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          title: AddressBox(
            addressId: addressId,
          ),
          titlePadding: EdgeInsets.zero,
        );
      },
    );
    await refreshPage();
  }

  Widget buildAddressItemCard(String addressId) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Dismissible(
        key: Key(addressId),
        direction: DismissDirection.horizontal,
        background: buildDismissibleSecondaryBackground(),
        secondaryBackground: buildDismissiblePrimaryBackground(),
        dismissThresholds: {
          DismissDirection.endToStart: 0.65,
          DismissDirection.startToEnd: 0.65,
        },
        child: AddressShortDetailsCard(
          addressId: addressId,
          onTap: () async {
            await addressItemTapCallback(addressId);
          },
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            final status = await deleteButtonCallback(context, addressId);
            return status;
          } else if (direction == DismissDirection.endToStart) {
            final status = await editButtonCallback(context, addressId);
            return status;
          }
          return false;
        },
        onDismissed: (direction) async {
          await refreshPage();
        },
      ),
    );
  }

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Chỉnh sửa",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDismissibleSecondaryBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Xoá",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
