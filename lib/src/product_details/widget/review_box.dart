import 'package:flutter/material.dart';
import 'package:flutter_online_shop/models/review_model.dart';
import 'package:flutter_online_shop/utils/constant.dart';

class ReviewBox extends StatelessWidget {
  final Review review;
  const ReviewBox({
    Key key,
    @required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              review.feedback ?? '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
              Text(
                "${review.rating.toString()}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
