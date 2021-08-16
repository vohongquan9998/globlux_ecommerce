import 'package:flutter/material.dart';
import 'package:flutter_online_shop/models/product_model.dart';
import 'package:flutter_online_shop/models/review_model.dart';
import 'package:flutter_online_shop/services/db/product_db_helper.dart';
import 'package:flutter_online_shop/src/product_details/widget/review_box.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/top_round_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(320),
      child: Stack(
        children: [
          TopRoundedContainer(
            child: Column(
              children: [
                Text(
                  "Đánh giá sản phẩm",
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Expanded(
                  child: StreamBuilder<List<Review>>(
                    stream: ProductDatabaseHelper()
                        .getAllReviewsStreamForProductId(product.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final reviewsList = snapshot.data;
                        if (reviewsList.length == 0) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/review.svg",
                                  color: kTextColor,
                                  width: 40,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Chưa có đánh giá",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: reviewsList.length,
                          itemBuilder: (context, index) {
                            return ReviewBox(
                              review: reviewsList[index],
                            );
                          },
                        );
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
                        child: Icon(
                          Icons.error,
                          color: kTextColor,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: getProportionateScreenWidth(screenPadding)),
            child: Align(
              alignment: Alignment.topRight,
              child: buildProductRatingWidget(product.rating),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductRatingWidget(num rating) {
    return Container(
      width: getProportionateScreenWidth(80),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[900],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$rating",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: getProportionateScreenWidth(16),
              ),
            ),
          ),
          SizedBox(width: 5),
          Icon(
            Icons.star,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
