import 'package:flutter/material.dart';
import 'package:flutter_online_shop/models/product_model.dart';
import 'package:flutter_online_shop/services/auth/auth_services.dart';
import 'package:flutter_online_shop/services/db/user_db_helper.dart';
import 'package:flutter_online_shop/src/product_details/widget/product_description.dart';
import 'package:flutter_online_shop/src/product_details/widget/provider/product_actions.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/utils/utils.dart';
import 'package:flutter_online_shop/widget/top_round_container.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ProductActionsSection extends StatelessWidget {
  final Product product;

  const ProductActionsSection({
    Key key,
    @required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final column = Column(
      children: [
        Stack(
          children: [
            TopRoundedContainer(
              child: ProductDescription(product: product),
            ),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: buildFavouriteButton(),
            // ),
          ],
        ),
      ],
    );
    UserDatabaseHelper().isProductFavourite(product.id).then(
      (value) {
        final productActions =
            Provider.of<ProductActions>(context, listen: false);
        productActions.productFavStatus = value;
      },
    ).catchError(
      (e) {
        Logger().w("$e");
      },
    );
    return column;
  }

  Widget buildFavouriteButton() {
    return Consumer<ProductActions>(
      builder: (context, productDetails, child) {
        return InkWell(
          onTap: () async {
            bool allowed = AuthentificationService().currentUserVerified;
            if (!allowed) {
              final reverify = await showConfirmationDialog(context,
                  "Bạn chưa xác minh địa chỉ email của mình. Hành động này chỉ được phép đối với những người dùng đã xác minh.",
                  positiveResponse: "Gửi email xác minh",
                  negativeResponse: "Trở về");
              if (reverify) {
                final future = AuthentificationService()
                    .sendVerificationEmailToCurrentUser();
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
            bool success = false;
            final future = UserDatabaseHelper()
                .switchProductFavouriteStatus(
                    product.id, !productDetails.productFavStatus)
                .then(
              (status) {
                success = status;
              },
            ).catchError(
              (e) {
                Logger().e(e.toString());
                success = false;
              },
            );
            await showDialog(
              context: context,
              builder: (context) {
                return FutureProgressDialog(
                  future,
                  message: Text(
                    productDetails.productFavStatus
                        ? "Removing from Favourites"
                        : "Adding to Favourites",
                  ),
                );
              },
            );
            if (success) {
              productDetails.switchProductFavStatus();
            }
          },
          child: Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(8)),
            decoration: BoxDecoration(
              color: productDetails.productFavStatus
                  ? Color(0xFFFFE6E6)
                  : Color(0xFFF5F6F9),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(8)),
              child: Icon(
                Icons.favorite,
                color: productDetails.productFavStatus
                    ? Color(0xFFFF4848)
                    : Color(0xFFD8DEE4),
              ),
            ),
          ),
        );
      },
    );
  }
}
