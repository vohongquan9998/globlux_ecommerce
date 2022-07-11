import 'package:flutter/material.dart';
import 'package:flutter_online_shop/models/product_model.dart';
import 'package:flutter_online_shop/services/auth/auth_services.dart';
import 'package:flutter_online_shop/services/db/product_db_helper.dart';
import 'package:flutter_online_shop/services/steams/all_product_stream.dart';
import 'package:flutter_online_shop/services/steams/favourite_product_stream.dart';
import 'package:flutter_online_shop/src/cart/cart_screen.dart';
import 'package:flutter_online_shop/src/category/category_screen.dart';
import 'package:flutter_online_shop/src/home/widget/header.dart';
import 'package:flutter_online_shop/src/home/widget/product_type_box.dart';
import 'package:flutter_online_shop/src/home/widget/products_sections.dart';
import 'package:flutter_online_shop/src/home/widget/slideRatingList.dart';
import 'package:flutter_online_shop/src/product_details/product_details_screen.dart';
import 'package:flutter_online_shop/src/search/search_screen.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/utils/utils.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

const String ICON_KEY = "icon";
const String TITLE_KEY = "title";
const String PRODUCT_TYPE_KEY = "product_type";

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final productCategories = <Map>[
    <String, dynamic>{
      ICON_KEY: "assets/icons/Electronics.svg",
      TITLE_KEY: "Đồ điện tử",
      PRODUCT_TYPE_KEY: ProductType.Electronics,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Books.svg",
      TITLE_KEY: "Sách",
      PRODUCT_TYPE_KEY: ProductType.Books,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Fashion.svg",
      TITLE_KEY: "Thời trang",
      PRODUCT_TYPE_KEY: ProductType.Fashion,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Groceries.svg",
      TITLE_KEY: "Thực phẩm",
      PRODUCT_TYPE_KEY: ProductType.Groceries,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Art.svg",
      TITLE_KEY: "Đồ trang trí",
      PRODUCT_TYPE_KEY: ProductType.Furniture,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Others.svg",
      TITLE_KEY: "Khác",
      PRODUCT_TYPE_KEY: ProductType.Others,
    },
  ];

  bool isType = false;

  final FavouriteProductsStream favouriteProductsStream =
      FavouriteProductsStream();
  final AllProductsStream allProductsStream = AllProductsStream();
  final AllProductsStream allRatingProductsStream = AllProductsStream();

  @override
  void initState() {
    super.initState();
    //favouriteProductsStream.init();
    allProductsStream.init();
    allRatingProductsStream.init();
  }

  @override
  void dispose() {
    //favouriteProductsStream.dispose();
    allProductsStream.dispose();
    allRatingProductsStream.init();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: RefreshIndicator(
            onRefresh: refreshPage,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(screenPadding)),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: getProportionateScreenHeight(15)),
                    HomeHeader(
                      onSearchSubmitted: (value) async {
                        final query = value.toString();
                        if (query.length <= 0) return;
                        List<String> searchedProductsId;
                        try {
                          searchedProductsId = await ProductDatabaseHelper()
                              .searchInProducts(query.toLowerCase());
                          if (searchedProductsId != null) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchResultScreen(
                                  searchQuery: query,
                                  searchResultProductsId: searchedProductsId,
                                  searchIn: "Tất cả sản phẩm",
                                ),
                              ),
                            );
                            await refreshPage();
                          } else {
                            throw "Thao tác thất bại,vui lòng thử lại";
                          }
                        } catch (e) {
                          final error = e.toString();
                          Logger().e(error);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("$error"),
                            ),
                          );
                        }
                      },
                      onCartButtonPressed: () async {
                        bool allowed =
                            AuthentificationService().currentUserVerified;
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
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartScreen(),
                          ),
                        );
                        await refreshPage();
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Danh mục",
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(20),
                                color: kPrimaryColor,
                                fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          children: [
                            ...List.generate(
                              productCategories.length,
                              (index) {
                                return ProductTypeBox(
                                  icon: productCategories[index][ICON_KEY],
                                  title: productCategories[index][TITLE_KEY],
                                  onPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryProductsScreen(
                                          productType: productCategories[index]
                                              [PRODUCT_TYPE_KEY],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.4,
                      child: SlideRatingList(
                        sectionTitle: "Đánh giá về sản phẩm",
                        productsStreamController: allRatingProductsStream,
                        emptyListMessage: "Hiện không có sản phẩm nào",
                        onProductCardTapped: onProductCardTapped,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: getProportionateScreenHeight(5)),
                          width: SizeConfig.screenWidth * .3,
                          height: SizeConfig.screenHeight * .05,
                          decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(.2),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.grid_view),
                                  onPressed: () {
                                    setState(() {
                                      isType = false;
                                    });
                                  }),
                              IconButton(
                                  icon: Icon(Icons.list),
                                  onPressed: () {
                                    setState(() {
                                      isType = true;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.8,
                      child: ProductsSection(
                        type: isType,
                        sectionTitle: "Tất cả sản phẩm",
                        productsStreamController: allProductsStream,
                        emptyListMessage: "Hiện tại chưa có sản phẩm nào cả",
                        onProductCardTapped: onProductCardTapped,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(80)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> refreshPage() {
    //favouriteProductsStream.reload();
    allProductsStream.reload();
    return Future<void>.value();
  }

  void onProductCardTapped(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: productId),
      ),
    ).then((_) async {
      await refreshPage();
    });
  }
}
