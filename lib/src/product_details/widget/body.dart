import 'package:flutter/material.dart';
import 'package:flutter_online_shop/models/product_model.dart';
import 'package:flutter_online_shop/services/db/product_db_helper.dart';
import 'package:flutter_online_shop/src/product_details/widget/product_actions_sections.dart';
import 'package:flutter_online_shop/src/product_details/widget/product_image.dart';
import 'package:flutter_online_shop/src/product_details/widget/product_review_sections.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:logger/logger.dart';

class Body extends StatelessWidget {
  final String productId;

  const Body({
    Key key,
    @required this.productId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding),
              vertical: getProportionateScreenHeight(screenPadding)),
          child: FutureBuilder<Product>(
            future: ProductDatabaseHelper().getProductWithID(productId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final product = snapshot.data;
                return Column(
                  children: [
                    ProductImages(product: product),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    ProductActionsSection(product: product),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    ProductReviewsSection(product: product),
                    SizedBox(height: getProportionateScreenHeight(100)),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                final error = snapshot.error.toString();
                Logger().e(error);
              }
              return Center(
                child: Icon(
                  Icons.error,
                  color: kTextColor,
                  size: 60,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
