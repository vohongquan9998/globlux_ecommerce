import 'package:flutter/material.dart';
import 'package:flutter_online_shop/models/product_model.dart';
import 'package:flutter_online_shop/services/db/product_db_helper.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

class ProductCardListView extends StatelessWidget {
  final String productId;
  final GestureTapCallback press;
  const ProductCardListView({
    Key key,
    @required this.productId,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Container(
          height: SizeConfig.screenHeight * .22,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: kTextColor.withOpacity(0.15)),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: FutureBuilder<Product>(
              future: ProductDatabaseHelper().getProductWithID(productId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final Product product = snapshot.data;
                  return buildProductCardItems(product);
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: Center(child: CircularProgressIndicator()),
                  );
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
      ),
    );
  }

  Row buildProductCardItems(Product product) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              product.images[0],
              width: SizeConfig.screenWidth * .2,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        SizedBox(
          width: getProportionateScreenWidth(10),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.screenWidth * .3,
              child: Text(
                '${product.title}',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: getProportionateScreenWidth(15),
            ),
            Row(
              children: [
                Text.rich(
                  TextSpan(
                    text: "${product.discountPrice}\đ\n",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: "${product.originalPrice}\đ",
                        style: TextStyle(
                          color: kTextColor,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.normal,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(20),
                ),
                Stack(
                  children: [
                    Positioned(
                      child: SvgPicture.asset(
                        "assets/icons/DiscountTag.svg",
                        color: kPrimaryColor.withOpacity(.4),
                        width: SizeConfig.screenWidth * .1,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(6),
                            left: getProportionateScreenWidth(8)),
                        child: Text(
                          "${product.calculatePercentageDiscount()}%",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: SizeConfig.screenWidth * .04,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
