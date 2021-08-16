import 'package:flutter_online_shop/services/db/user_db_helper.dart';
import 'package:flutter_online_shop/services/steams/data_stream.dart';

class OrderedProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final orderedProductsFuture = UserDatabaseHelper().orderedProductsList;
    orderedProductsFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
