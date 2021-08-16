import 'package:flutter/material.dart';
import 'package:flutter_online_shop/src/product_details/widget/provider/expand_text.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:provider/provider.dart';

class ExpandableText extends StatelessWidget {
  final String title;
  final String content;
  final int maxLines;
  const ExpandableText({
    Key key,
    @required this.title,
    @required this.content,
    this.maxLines = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpandText(),
      child: Consumer<ExpandText>(builder: (context, expandText, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Divider(
              height: 8,
              thickness: 1,
              endIndent: 16,
            ),
            Text(
              content,
              maxLines: expandText.isExpanded ? null : maxLines,
              textAlign: TextAlign.left,
            ),
            GestureDetector(
              onTap: () {
                expandText.isExpanded ^= true;
              },
              child: Row(
                children: [
                  Text(
                    expandText.isExpanded == false
                        ? "Xem thêm".toUpperCase()
                        : "Thu gọn".toUpperCase(),
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
