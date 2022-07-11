import 'package:flutter/material.dart';
import 'package:flutter_online_shop/models/product_model.dart';
import 'package:flutter_online_shop/services/db/product_db_helper.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:logger/logger.dart';

class SlideRatingItem extends StatelessWidget {
  final String productId;
  final GestureTapCallback press;

  const SlideRatingItem({Key key, this.productId, this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kTextColor.withOpacity(0.15)),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: FutureBuilder<Product>(
            future: ProductDatabaseHelper().getProductWithID(productId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final Product product = snapshot.data;
                return buildProductRatingCardItems(product);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
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
    );
  }

  Column buildProductRatingCardItems(Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.images[0],
                    fit: BoxFit.fill,
                    width: SizeConfig.screenWidth * .3,
                  ),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(20),
              ),
              Container(
                width: SizeConfig.screenWidth * .18,
                height: SizeConfig.screenWidth * .18,
                child: ClipOval(
                  child: Container(
                    color: Colors.amber,
                    child: Center(
                      child: Text(
                        '★\t${product.rating}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenHeight(20),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  "${product.title}\n",
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
