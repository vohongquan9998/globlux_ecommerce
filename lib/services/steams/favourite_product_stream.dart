import 'package:flutter_online_shop/services/db/user_db_helper.dart';
import 'package:flutter_online_shop/services/steams/data_stream.dart';

class FavouriteProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final favProductsFuture = UserDatabaseHelper().usersFavouriteProductsList;
    favProductsFuture.then((favProducts) {
      addData(favProducts.cast<String>());
    }).catchError((e) {
      addError(e);
    });
  }
}
