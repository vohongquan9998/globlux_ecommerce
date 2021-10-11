import 'package:flutter/material.dart';
import 'package:flutter_online_shop/src/home/widget/body.dart';
import 'package:flutter_online_shop/src/home/widget/drawer.dart';
import 'package:flutter_online_shop/utils/size_config.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: GestureDetector(
         onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
         child: Stack(
            children: [
               HomeBody(),
            ],
         ),
      ),
      drawer: HomeScreenDrawer(),
    );
  }
}
