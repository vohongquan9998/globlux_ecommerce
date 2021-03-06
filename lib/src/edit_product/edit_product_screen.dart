import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_shop/exceptions/local_file/image_picking_exceptions.dart';
import 'package:flutter_online_shop/exceptions/local_file/local_files_exceptions.dart';
import 'package:flutter_online_shop/models/product_model.dart';
import 'package:flutter_online_shop/services/db/product_db_helper.dart';
import 'package:flutter_online_shop/services/file_access/fs_files_access.dart';
import 'package:flutter_online_shop/services/local_files_access/local_files_access.dart';
import 'package:flutter_online_shop/src/edit_product/widget/edit_product_provider.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/default_button.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  final Product productToEdit;

  const EditProductScreen({Key key, this.productToEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetails(),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(screenPadding)),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(10)),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    EditProductForm(product: productToEdit),
                    SizedBox(height: getProportionateScreenHeight(30)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditProductForm extends StatefulWidget {
  final Product product;
  EditProductForm({
    Key key,
    this.product,
  }) : super(key: key);

  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final _basicDetailsFormKey = GlobalKey<FormState>();
  final _describeProductFormKey = GlobalKey<FormState>();
  final _tagStateKey = GlobalKey<TagsState>();

  final TextEditingController titleFieldController = TextEditingController();
  final TextEditingController variantFieldController = TextEditingController();
  final TextEditingController discountPriceFieldController =
      TextEditingController();
  final TextEditingController originalPriceFieldController =
      TextEditingController();
  final TextEditingController highlightsFieldController =
      TextEditingController();
  final TextEditingController desciptionFieldController =
      TextEditingController();
  final TextEditingController sellerFieldController = TextEditingController();

  bool newProduct = true;
  Product product;
  String s = "";
  ProductDetails _productDetails;
  @override
  void dispose() {
    titleFieldController.dispose();
    variantFieldController.dispose();
    discountPriceFieldController.dispose();
    originalPriceFieldController.dispose();
    highlightsFieldController.dispose();
    desciptionFieldController.dispose();
    sellerFieldController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.product == null) {
      product = Product(null);
      newProduct = true;
    } else {
      product = widget.product;
      newProduct = false;
      final productDetails =
          Provider.of<ProductDetails>(context, listen: false);
      productDetails.initialSelectedImages = widget.product.images
          .map((e) => CustomImage(imgType: ImageType.network, path: e))
          .toList();
      productDetails.initialProductType = product.productType;
      productDetails.initSearchTags = product.searchTags ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final column = Column(
      children: [
        buildBasicDetailsTile(context),
        SizedBox(height: getProportionateScreenHeight(10)),
        buildDescribeProductTile(context),
        SizedBox(height: getProportionateScreenHeight(10)),
        buildUploadImagesTile(context),
        SizedBox(height: getProportionateScreenHeight(20)),
        buildProductTypeDropdown(),
        SizedBox(height: getProportionateScreenHeight(20)),
        buildProductSearchTagsTile(),
        SizedBox(height: getProportionateScreenHeight(80)),
        DefaultButton(
            text: "L??u s???n ph???m",
            press: () {
              saveProductButtonCallback(context);
            }),
        SizedBox(height: getProportionateScreenHeight(10)),
      ],
    );
    if (newProduct == false) {
      titleFieldController.text = product.title;
      variantFieldController.text = product.variant;
      discountPriceFieldController.text = product.discountPrice.toString();
      originalPriceFieldController.text = product.originalPrice.toString();
      highlightsFieldController.text = product.highlights;
      desciptionFieldController.text = product.description;
      sellerFieldController.text = product.seller;
    }
    return column;
  }

  Widget buildProductSearchTags() {
    return Consumer<ProductDetails>(
      builder: (context, productDetails, child) {
        return Tags(
          key: _tagStateKey,
          horizontalScroll: true,
          heightHorizontalScroll: getProportionateScreenHeight(80),
          textField: TagsTextField(
            lowerCase: true,
            width: getProportionateScreenWidth(150),
            constraintSuggestion: true,
            hintText: "Th??m th??? t??m ki???m",
            keyboardType: TextInputType.name,
            onSubmitted: (String str) {
              setState(() {
                s = str;
                _productDetails = productDetails;
              });
              productDetails.addSearchTag(str.toLowerCase());
            },
          ),
          itemCount: productDetails.searchTags.length,
          itemBuilder: (index) {
            final item = productDetails.searchTags[index];
            return ItemTags(
              index: index,
              title: item,
              active: true,
              activeColor: kPrimaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              alignment: MainAxisAlignment.spaceBetween,
              removeButton: ItemTagsRemoveButton(
                backgroundColor: Colors.white,
                color: kTextColor,
                onRemoved: () {
                  productDetails.removeSearchTag(index: index);
                  return true;
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget buildBasicDetailsTile(BuildContext context) {
    return Form(
      key: _basicDetailsFormKey,
      child: ExpansionTile(
        maintainState: true,
        title: Text(
          "Chi ti???t c?? b???n",
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: Icon(
          Icons.shop,
          color: kPrimaryColor,
        ),
        childrenPadding:
            EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
        children: [
          buildTitleField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildVariantField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildOriginalPriceField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildDiscountPriceField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildSellerField(),
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
      ),
    );
  }

  bool validateBasicDetailsForm() {
    if (_basicDetailsFormKey.currentState.validate()) {
      _basicDetailsFormKey.currentState.save();
      product.title = titleFieldController.text;
      product.variant = variantFieldController.text;
      product.originalPrice = double.parse(originalPriceFieldController.text);
      product.discountPrice = double.parse(discountPriceFieldController.text);
      product.seller = sellerFieldController.text;
      return true;
    }
    return false;
  }

  Widget buildDescribeProductTile(BuildContext context) {
    return Form(
      key: _describeProductFormKey,
      child: ExpansionTile(
        maintainState: true,
        title: Text(
          "M?? t??? s???n ph???m",
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: Icon(
          Icons.description,
          color: kPrimaryColor,
        ),
        childrenPadding:
            EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
        children: [
          buildHighlightsField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildDescriptionField(),
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
      ),
    );
  }

  bool validateDescribeProductForm() {
    if (_describeProductFormKey.currentState.validate()) {
      _describeProductFormKey.currentState.save();
      product.highlights = highlightsFieldController.text;
      product.description = desciptionFieldController.text;
      return true;
    }
    return false;
  }

  Widget buildProductTypeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      child: Consumer<ProductDetails>(
        builder: (context, productDetails, child) {
          return DropdownButton(
            value: productDetails.productType,
            items: ProductType.values
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      EnumToString.convertToString(e),
                    ),
                  ),
                )
                .toList(),
            hint: Text(
              "Ch???n lo???i s???n ph???m",
            ),
            style: TextStyle(
              color: kTextColor,
              fontSize: 16,
            ),
            onChanged: (value) {
              productDetails.productType = value;
            },
            elevation: 0,
            underline: SizedBox(width: 0, height: 0),
          );
        },
      ),
    );
  }

  Widget buildProductSearchTagsTile() {
    return ExpansionTile(
      title: Text(
        "Th??? t??m ki???m",
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: Icon(
        Icons.check_circle_sharp,
        color: kPrimaryColor,
      ),
      childrenPadding:
          EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
      children: [
        Text("S???n ph???m c???a b???n s??? ???????c t??m ki???m khi nh???p Th??? n??y"),
        SizedBox(height: getProportionateScreenHeight(15)),
        buildProductSearchTags(),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kPrimaryColor,
          ),
          child: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _productDetails.addSearchTag(s.toLowerCase());
            },
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget buildUploadImagesTile(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "????ng h??nh ???nh",
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: Icon(
        Icons.image,
        color: kPrimaryColor,
      ),
      childrenPadding:
          EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
              ),
              color: kTextColor,
              onPressed: () {
                addImageButtonCallback();
              }),
        ),
        Consumer<ProductDetails>(
          builder: (context, productDetails, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  productDetails.selectedImages.length,
                  (index) => SizedBox(
                    width: 80,
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          addImageButtonCallback(index: index);
                        },
                        child: productDetails.selectedImages[index].imgType ==
                                ImageType.local
                            ? Image.memory(
                                File(productDetails.selectedImages[index].path)
                                    .readAsBytesSync())
                            : Image.network(
                                productDetails.selectedImages[index].path),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget buildTitleField() {
    return TextFormField(
      controller: titleFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "e.g., iPhone 12 Pro Max",
        labelText: "Ti??u ????? s???n ph???m",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (titleFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildVariantField() {
    return TextFormField(
      controller: variantFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "e.g., Xanh da tr???i",
        labelText: "M??u",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (variantFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildHighlightsField() {
    return TextFormField(
      controller: highlightsFieldController,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText:
            "e.g., RAM: 4GB | Front Camera: 30MP | Rear Camera: Quad Camera Setup",
        labelText: "??i???m n???i b???t",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (highlightsFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: null,
    );
  }

  Widget buildDescriptionField() {
    return TextFormField(
      controller: desciptionFieldController,
      keyboardType: TextInputType.multiline,
      minLines: 5,
      decoration: InputDecoration(
        hintText:
            "e.g., iPhone 12 Pro Max s??? h???u di???n \nm???o m???i v???i khung vi???n ???????c v??t\nth???ng v?? m???nh m??? nh?? tr??n iPad Pro\n2020,ch???m d???t h??n 6 n??m v???i ki???u \nthi???t k??? bo cong tr??n iPhone 6 ???????c ra m???t l???n ?????u ti??n v??o n??m 2014.",
        labelText: "M?? t??? s???n ph???m",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (desciptionFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: null,
    );
  }

  Widget buildSellerField() {
    return TextFormField(
      controller: sellerFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "e.g., Zara",
        labelText: "????n v??? b??n h??ng",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (sellerFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildOriginalPriceField() {
    return TextFormField(
      controller: originalPriceFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "e.g., 12.000.000.0??",
        labelText: "Gi?? g???c (Vi???t Nam)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (originalPriceFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildDiscountPriceField() {
    return TextFormField(
      controller: discountPriceFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "e.g., 11.000.000.0??",
        labelText: "Gi?? b??n(???? gi???m gi??)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (_) {
        if (discountPriceFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> saveProductButtonCallback(BuildContext context) async {
    if (validateBasicDetailsForm() == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("L???i trong Bi???u m???u Chi ti???t C?? b???n"),
        ),
      );
      return;
    }
    if (validateDescribeProductForm() == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("L???i trong M?? t??? S???n ph???m"),
        ),
      );
      return;
    }
    final productDetails = Provider.of<ProductDetails>(context, listen: false);
    if (productDetails.selectedImages.length < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("??t nh???t m???t h??nh ???nh v??? s???n ph???m ???????c t???i l??n"),
        ),
      );
      return;
    }
    if (productDetails.productType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui l??ng ch???n Lo???i s???n ph???m"),
        ),
      );
      return;
    }
    if (productDetails.searchTags.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("C???n ??t nh???t 3 Th??? t??m ki???m"),
        ),
      );
      return;
    }
    String productId;
    String snackbarMessage;
    try {
      product.productType = productDetails.productType;
      product.searchTags = productDetails.searchTags;
      final productUploadFuture = newProduct
          ? ProductDatabaseHelper().addUsersProduct(product)
          : ProductDatabaseHelper().updateUsersProduct(product);
      productUploadFuture.then((value) {
        productId = value;
      });
      await showDialog(
        context: context,
        builder: (context) {
          return FutureProgressDialog(
            productUploadFuture,
            message: Text(newProduct
                ? "??ang ti???n h??nh ????ng t???i s???n ph???m"
                : "??ang ti???n h??nh c???p nh???t s???n ph???m"),
          );
        },
      );
      if (productId != null) {
        snackbarMessage = "C???p nh???t th??ng tin s???n ph???m th??nh c??ng";
      } else {
        throw "Thao t??c th???t b???i,vui l??ng th??? l???i";
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
    if (productId == null) return;
    bool allImagesUploaded = false;
    try {
      allImagesUploaded = await uploadProductImages(productId);
      if (allImagesUploaded == true) {
        snackbarMessage = "????ng t???t c??? h??nh ???nh th??nh c??ng";
      } else {
        throw "Kh??ng th??? t???i l??n m???t s??? h??nh ???nh, vui l??ng th??? l???i";
      }
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
      snackbarMessage = "Something went wrong";
    } catch (e) {
      Logger().w("Unknown Exception: $e");
      snackbarMessage = "Something went wrong";
    } finally {
      Logger().i(snackbarMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage),
        ),
      );
    }
    List<String> downloadUrls = productDetails.selectedImages
        .map((e) => e.imgType == ImageType.network ? e.path : null)
        .toList();
    bool productFinalizeUpdate = false;
    try {
      final updateProductFuture =
          ProductDatabaseHelper().updateProductsImages(productId, downloadUrls);
      productFinalizeUpdate = await showDialog(
        context: context,
        builder: (context) {
          return FutureProgressDialog(
            updateProductFuture,
            message: Text("??ang ti???n h??nh l??u s???n ph???m"),
          );
        },
      );
      if (productFinalizeUpdate == true) {
        snackbarMessage = "????ng t???i s???n ph???m th??nh c??ng";
      } else {
        throw "Thao t??c th???t b???i,vui l??ng th??? l???i";
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
    Navigator.pop(context);
  }

  Future<bool> uploadProductImages(String productId) async {
    bool allImagesUpdated = true;
    final productDetails = Provider.of<ProductDetails>(context, listen: false);
    for (int i = 0; i < productDetails.selectedImages.length; i++) {
      if (productDetails.selectedImages[i].imgType == ImageType.local) {
        print(
            "H??nh ???nh ???????c t???i l??n: " + productDetails.selectedImages[i].path);
        String downloadUrl;
        try {
          final imgUploadFuture = FirestoreFilesAccess().uploadFileToPath(
              File(productDetails.selectedImages[i].path),
              ProductDatabaseHelper().getPathForProductImage(productId, i));
          downloadUrl = await showDialog(
            context: context,
            builder: (context) {
              return FutureProgressDialog(
                imgUploadFuture,
                message: Text(
                    "??ang t???i h??nh ???nh ${i + 1}/${productDetails.selectedImages.length}"),
              );
            },
          );
        } on FirebaseException catch (e) {
          Logger().w("Firebase Exception: $e");
        } catch (e) {
          Logger().w("Firebase Exception: $e");
        } finally {
          if (downloadUrl != null) {
            productDetails.selectedImages[i] =
                CustomImage(imgType: ImageType.network, path: downloadUrl);
          } else {
            allImagesUpdated = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Kh??ng th??? t???i l??n h??nh ???nh ${i + 1} do m???t s??? v???n ?????"),
              ),
            );
          }
        }
      }
    }
    return allImagesUpdated;
  }

  Future<void> addImageButtonCallback({int index}) async {
    final productDetails = Provider.of<ProductDetails>(context, listen: false);
    if (index == null && productDetails.selectedImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("C?? th??? t???i l??n t???i ??a 3 h??nh ???nh")));
      return;
    }
    String path;
    String snackbarMessage;
    try {
      path = await choseImageFromLocalFiles(context);
      if (path == null) {
        throw LocalImagePickingUnknownReasonFailureException();
      }
    } on LocalFileHandlingException catch (e) {
      Logger().i("Local File Handling Exception: $e");
      snackbarMessage = e.toString();
    } catch (e) {
      Logger().i("Unknown Exception: $e");
      snackbarMessage = e.toString();
    } finally {
      if (snackbarMessage != null) {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
    if (path == null) {
      return;
    }
    if (index == null) {
      productDetails.addNewSelectedImage(
          CustomImage(imgType: ImageType.local, path: path));
    } else {
      productDetails.setSelectedImageAtIndex(
          CustomImage(imgType: ImageType.local, path: path), index);
    }
  }
}
