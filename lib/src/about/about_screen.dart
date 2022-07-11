import 'package:flutter/material.dart';

import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';

class AboutDeveloperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getProportionateScreenHeight(30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * .9,
                      height: SizeConfig.screenHeight * .9,
                      decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(.3),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                getProportionateScreenWidth(screenPadding),
                            vertical:
                                getProportionateScreenHeight(screenPadding)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'About us',
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  color: Colors.grey,
                                  height: 3,
                                  width: SizeConfig.screenWidth * .21,
                                ),
                                Text(
                                  'Version',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  color: Colors.grey,
                                  height: 3,
                                  width: SizeConfig.screenWidth * .21,
                                ),
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'v1.11',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  color: Colors.grey,
                                  height: 3,
                                  width: SizeConfig.screenWidth * .17,
                                ),
                                Text(
                                  'Technology',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  color: Colors.grey,
                                  height: 3,
                                  width: SizeConfig.screenWidth * .17,
                                ),
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Flutter Framework',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Firebase Firestore',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Firebase Storage',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  color: Colors.grey,
                                  height: 3,
                                  width: SizeConfig.screenWidth * .15,
                                ),
                                Text(
                                  'Team author',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  color: Colors.grey,
                                  height: 3,
                                  width: SizeConfig.screenWidth * .15,
                                ),
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Võ Hồng Quân',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cao Hồng Chương',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Nguyễn Hoàng Hải',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
