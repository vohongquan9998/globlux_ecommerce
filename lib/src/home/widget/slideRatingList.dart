import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_shop/services/steams/data_stream.dart';
import 'package:flutter_online_shop/src/home/widget/section_tile.dart';

import 'package:flutter_online_shop/src/home/widget/slideRatingItem.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/nothing_show.dart';
import 'package:logger/logger.dart';

class SlideRatingList extends StatelessWidget {
  final String sectionTitle;
  final DataStream productsStreamController;
  final String emptyListMessage;
  final Function onProductCardTapped;

  const SlideRatingList(
      {Key key,
      this.sectionTitle,
      this.productsStreamController,
      this.emptyListMessage,
      this.onProductCardTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          SectionTile(
            title: sectionTitle,
            press: () {},
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          Expanded(
            child: buildProductsList(),
          ),
        ],
      ),
    );
  }

  Widget buildProductsList() {
    return StreamBuilder<List<String>>(
      stream: productsStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: NothingToShowContainer(
                secondaryMessage: emptyListMessage,
              ),
            );
          }
          return buildProductSlider(snapshot.data);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
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
    );
  }

  Widget buildProductSlider(List<String> productsId) {
    return CarouselSlider.builder(
      itemCount: productsId.length,
      itemBuilder: (BuildContext context, int index, int i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SlideRatingItem(
            productId: productsId[index],
            press: () {
              onProductCardTapped.call(productsId[index]);
            },
          ),
        );
      },
      options: CarouselOptions(
        height: SizeConfig.screenHeight * .3,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        enlargeCenterPage: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        enableInfiniteScroll: false,
      ),
    );
  }
}
