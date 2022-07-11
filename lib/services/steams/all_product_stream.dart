import 'package:flutter_online_shop/services/db/product_db_helper.dart';
import 'package:flutter_online_shop/services/steams/data_stream.dart';

class AllProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final allProductsFuture = ProductDatabaseHelper().allProductsList;
    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
