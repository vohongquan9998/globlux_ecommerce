import 'package:flutter_online_shop/services/db/user_db_helper.dart';
import 'package:flutter_online_shop/services/steams/data_stream.dart';

class AddressesStream extends DataStream<List<String>> {
  @override
  void reload() {
    final addressesList = UserDatabaseHelper().addressesList;
    addressesList.then((list) {
      addData(list);
    }).catchError((e) {
      addError(e);
    });
  }
}
