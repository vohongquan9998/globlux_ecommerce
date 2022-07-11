import 'package:flutter/material.dart';
import 'package:flutter_online_shop/src/product_details/product_details_screen.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/nothing_show.dart';
import 'package:flutter_online_shop/widget/product_card.dart';

class SearchResultScreen extends StatelessWidget {
  final String searchQuery;
  final String searchIn;
  final List<String> searchResultProductsId;

  const SearchResultScreen({
    Key key,
    @required this.searchQuery,
    @required this.searchResultProductsId,
    @required this.searchIn,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SearchBody(
        searchQuery: searchQuery,
        searchResultProductsId: searchResultProductsId,
        searchIn: searchIn,
      ),
    );
  }
}

class SearchBody extends StatelessWidget {
  final String searchQuery;
  final List<String> searchResultProductsId;
  final String searchIn;

  const SearchBody({
    Key key,
    @required this.searchQuery,
    @required this.searchResultProductsId,
    @required this.searchIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(10)),
                Text(
                  "Kết quả tìm kiếm",
                  style: headingStyle,
                ),
                Text.rich(
                  TextSpan(
                    text: "$searchQuery",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    children: [
                      TextSpan(
                        text: " ở ",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      TextSpan(
                        text: "$searchIn",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.75,
                  child: buildProductsGrid(),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProductsGrid() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Builder(
        builder: (context) {
          if (searchResultProductsId.length > 0) {
            return GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: searchResultProductsId.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  productId: searchResultProductsId[index],
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          productId: searchResultProductsId[index],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: NothingToShowContainer(
              iconPath: "assets/icons/search_no_found.svg",
              secondaryMessage: "Tìm thấy 0 sản phẩm",
              primaryMessage: "Hãy thử một từ khóa tìm kiếm khác",
            ),
          );
        },
      ),
    );
  }
}
