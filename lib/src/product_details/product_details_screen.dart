import 'package:flutter/material.dart';
import 'package:flutter_online_shop/src/product_details/widget/add_to_cart.dart';
import 'package:flutter_online_shop/src/product_details/widget/body.dart';
import 'package:flutter_online_shop/src/product_details/widget/provider/product_actions.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({
    Key key,
    @required this.productId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductActions(),
      child: Scaffold(
        backgroundColor: Colors.lightGreen[300],
        appBar: AppBar(
          backgroundColor: Colors.lightGreen[300],
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Body(
          productId: productId,
        ),
        floatingActionButton: AddToCartFAB(productId: productId),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
