import 'package:flutter/material.dart';
import 'package:flutter_online_shop/services/steams/data_stream.dart';
import 'package:flutter_online_shop/src/home/widget/section_tile.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/nothing_show.dart';
import 'package:flutter_online_shop/widget/product_card.dart';
import 'package:flutter_online_shop/widget/product_card_listview.dart';
import 'package:logger/logger.dart';

class ProductsSection extends StatelessWidget {
  final String sectionTitle;
  final DataStream productsStreamController;
  final String emptyListMessage;
  final Function onProductCardTapped;
  final bool type;

  const ProductsSection({
    Key key,
    @required this.sectionTitle,
    @required this.productsStreamController,
    this.emptyListMessage = "Hiện tại không có sản phẩm",
    @required this.onProductCardTapped,
    this.type = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          SectionTile(
            title: sectionTitle,
            press: () {},
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          Expanded(
            child: buildProductsList(),
          ),
        ],
      ),
    );
  }

  Widget buildProductsList() {
    return StreamBuilder<List<String>>(
      stream: productsStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: NothingToShowContainer(
                secondaryMessage: emptyListMessage,
              ),
            );
          }
          return !type
              ? buildProductGrid(snapshot.data)
              : buildProductList(snapshot.data);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
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
    );
  }

  Widget buildProductGrid(List<String> productsId) {
    return GridView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: productsId.length,
      itemBuilder: (context, index) {
        return ProductCard(
          productId: productsId[index],
          press: () {
            onProductCardTapped.call(productsId[index]);
          },
        );
      },
    );
  }

  Widget buildProductList(List<String> productsId) {
    return Padding(
      padding: EdgeInsets.only(right: getProportionateScreenWidth(50)),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: productsId.length,
        itemBuilder: (context, index) {
          return ProductCardListView(
            productId: productsId[index],
            press: () {
              onProductCardTapped.call(productsId[index]);
            },
          );
        },
      ),
    );
  }
}
