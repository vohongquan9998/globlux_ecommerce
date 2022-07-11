import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_online_shop/models/product_model.dart';
import 'package:flutter_online_shop/src/product_details/widget/expand_text_widget.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: product.title,
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: "\nColor:\t${product.variant} ",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: getProportionateScreenHeight(64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    child: Text.rich(
                      TextSpan(
                        text: "${product.discountPrice}\đ   ",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                        children: [
                          TextSpan(
                            text: "\n${product.originalPrice}\đ",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: kTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/Discount.svg",
                          color: kPrimaryColor,
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: getProportionateScreenWidth(
                                    screenPadding * .7),
                                top: getProportionateScreenHeight(
                                    screenPadding * 1.5)),
                            child: Transform.rotate(
                              angle: 30 * pi / 180,
                              child: Text(
                                "${product.calculatePercentageDiscount()}%\n",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenHeight(20),
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ExpandableText(
              title: "Chi tiết sản phẩm".toUpperCase(),
              content: product.highlights,
            ),
            const SizedBox(height: 16),
            ExpandableText(
              title: "Miêu tả sản phẩm".toUpperCase(),
              content: product.description,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Người đăng: ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: SizeConfig.screenWidth * .4,
                  height: SizeConfig.screenHeight * .05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kPrimaryColor.withOpacity(.8)),
                  child: Center(
                    child: Text(
                      "${product.seller}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Text.rich(
            //   TextSpan(
            //     text: "Người đăng: ",
            //     style: TextStyle(
            //       fontSize: 15,
            //       fontWeight: FontWeight.bold,
            //     ),
            //     children: [
            //       TextSpan(
            //         text: "${product.seller}",
            //         style: TextStyle(color: Colors.black),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
