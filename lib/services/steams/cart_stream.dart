import 'package:flutter_online_shop/services/db/user_db_helper.dart';
import 'package:flutter_online_shop/services/steams/data_stream.dart';

class CartItemsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final allProductsFuture = UserDatabaseHelper().allCartItemsList;
    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
