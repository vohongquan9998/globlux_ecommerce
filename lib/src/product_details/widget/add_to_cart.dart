import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_shop/services/auth/auth_services.dart';
import 'package:flutter_online_shop/services/db/user_db_helper.dart';
import 'package:flutter_online_shop/utils/utils.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

class AddToCartFAB extends StatelessWidget {
  const AddToCartFAB({
    Key key,
    @required this.productId,
  }) : super(key: key);

  final String productId;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        bool allowed = AuthentificationService().currentUserVerified;
        if (!allowed) {
          final reverify = await showConfirmationDialog(context,
              "Bạn chưa xác minh địa chỉ email của mình. Hành động này chỉ được phép đối với những người dùng đã xác minh.",
              positiveResponse: "Gửi email xác minh",
              negativeResponse: "Trở về");
          if (reverify) {
            final future =
                AuthentificationService().sendVerificationEmailToCurrentUser();
            await showDialog(
              context: context,
              builder: (context) {
                return FutureProgressDialog(
                  future,
                  message: Text(
                      "Đang tiến hành gửi xác minh.\nVui lòng đợi trong giây lát"),
                );
              },
            );
          }
          return;
        }
        bool addedSuccessfully = false;
        String snackbarMessage;
        try {
          addedSuccessfully =
              await UserDatabaseHelper().addProductToCart(productId);
          if (addedSuccessfully == true) {
            snackbarMessage = "Thêm sản phẩm thành công";
          } else {
            throw "Thao tác thất bại,vui lòng thử lại";
          }
        } on FirebaseException catch (e) {
          Logger().w("Firebase Exception: $e");
          snackbarMessage = "Thao tác thất bại,vui lòng thử lại";
        } catch (e) {
          Logger().w("Unknown Exception: $e");
          snackbarMessage = "Thao tác thất bại,vui lòng thử lại";
        } finally {
          Logger().i(snackbarMessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(snackbarMessage),
            ),
          );
        }
      },
      label: Text(
        "Thêm giỏ hàng",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      icon: Icon(
        Icons.shopping_cart,
      ),
    );
  }
}
