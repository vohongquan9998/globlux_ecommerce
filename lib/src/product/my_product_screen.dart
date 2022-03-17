import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_shop/models/product_model.dart';
import 'package:flutter_online_shop/services/db/product_db_helper.dart';
import 'package:flutter_online_shop/services/file_access/fs_files_access.dart';
import 'package:flutter_online_shop/services/steams/user_product_stream.dart';
import 'package:flutter_online_shop/src/edit_product/edit_product_screen.dart';
import 'package:flutter_online_shop/src/product_details/product_details_screen.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/utils/utils.dart';
import 'package:flutter_online_shop/widget/nothing_show.dart';
import 'package:flutter_online_shop/widget/product_short_detail_card.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

class MyProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ProductBody(),
      //body: Body(),
    );
  }
}

class ProductBody extends StatefulWidget {
  @override
  _ProductBodyState createState() => _ProductBodyState();
}

class _ProductBodyState extends State<ProductBody> {
  final UsersProductsStream usersProductsStream = UsersProductsStream();

  @override
  void initState() {
    super.initState();
    usersProductsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    usersProductsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Container(
                    width: SizeConfig.screenWidth * .9,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(SizeConfig.screenWidth * .01),
                    child: Row(
                      children: [
                        Icon(
                          Icons.help,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * .03,
                        ),
                        Text(
                          "Vuốt sang TRÁI để CHỈNH SỬA - Vuốt sang PHẢI để XOÁ"
                              .toUpperCase(),
                          style: TextStyle(
                              fontSize: SizeConfig.screenWidth * .025,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.7,
                    child: StreamBuilder<List<String>>(
                      stream: usersProductsStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final productsIds = snapshot.data;
                          if (productsIds.length == 0) {
                            return Center(
                              child: NothingToShowContainer(
                                secondaryMessage:
                                    "Trở thành người bán hàng của chúng tôi bằng cách thêm sản phẩm đầu tiên nào",
                              ),
                            );
                          }
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: productsIds.length,
                            itemBuilder: (context, index) {
                              return buildProductsCard(productsIds[index]);
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
                          child: NothingToShowContainer(
                            iconPath: "assets/icons/network_error.svg",
                            primaryMessage: "Something went wrong",
                            secondaryMessage: "Unable to connect to Database",
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(60)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    usersProductsStream.reload();
    return Future<void>.value();
  }

  Widget buildProductsCard(String productId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FutureBuilder<Product>(
        future: ProductDatabaseHelper().getProductWithID(productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data;
            return buildProductDismissible(product);
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
    );
  }

  Widget buildProductDismissible(Product product) {
    return Dismissible(
      key: Key(product.id),
      direction: DismissDirection.horizontal,
      background: buildDismissibleSecondaryBackground(),
      secondaryBackground: buildDismissiblePrimaryBackground(),
      dismissThresholds: {
        DismissDirection.endToStart: 0.65,
        DismissDirection.startToEnd: 0.65,
      },
      child: ProductShortDetailCard(
        productId: product.id,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                productId: product.id,
              ),
            ),
          );
        },
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirmation = await showConfirmationDialog(
              context, "Bạn có chắc muốn xoá sản phẩm này?");
          if (confirmation) {
            for (int i = 0; i < product.images.length; i++) {
              String path =
                  ProductDatabaseHelper().getPathForProductImage(product.id, i);
              final deletionFuture =
                  FirestoreFilesAccess().deleteFileFromPath(path);
              await showDialog(
                context: context,
                builder: (context) {
                  return FutureProgressDialog(
                    deletionFuture,
                    message:
                        Text("Đang xoá ảnh ${i + 1}/${product.images.length}"),
                  );
                },
              );
            }

            bool productInfoDeleted = false;
            String snackbarMessage;
            try {
              final deleteProductFuture =
                  ProductDatabaseHelper().deleteUserProduct(product.id);
              productInfoDeleted = await showDialog(
                context: context,
                builder: (context) {
                  return FutureProgressDialog(
                    deleteProductFuture,
                    message: Text("Đang xoá sản phẩm"),
                  );
                },
              );
              if (productInfoDeleted == true) {
                snackbarMessage = "Loại bỏ sản phẩm thành công";
              } else {
                throw "Thao tác thất bại,vui lòng thử lại";
              }
            } on FirebaseException catch (e) {
              Logger().w("Firebase Exception: $e");
              snackbarMessage = "Something went wrong";
            } catch (e) {
              Logger().w("Unknown Exception: $e");
              snackbarMessage = e.toString();
            } finally {
              Logger().i(snackbarMessage);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(snackbarMessage),
                ),
              );
            }
          }
          await refreshPage();
          return confirmation;
        } else if (direction == DismissDirection.endToStart) {
          final confirmation = await showConfirmationDialog(
              context, "Bạn có chắc muốn chỉnh sửa không?");
          if (confirmation) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProductScreen(
                  productToEdit: product,
                ),
              ),
            );
          }
          await refreshPage();
          return false;
        }
        return false;
      },
      onDismissed: (direction) async {
        await refreshPage();
      },
    );
  }

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Chỉnh sửa",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDismissibleSecondaryBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Xoá",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
