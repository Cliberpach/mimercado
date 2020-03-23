import 'package:anvic/util/Config.dart';
import 'package:flutter/material.dart';
import 'global_text.dart';

class WidgetProduct extends StatelessWidget {
  String imgUrl;
  String imgPlaceholder;
  String title;
  String description;
  String floating;
  VoidCallback callback;

  WidgetProduct({
    Key key,
    this.imgUrl = "",
    this.imgPlaceholder = "",
    this.title = "",
    this.description = "",
    this.floating = "",
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 120,
      width: 170,
      child: Stack(
        children: <Widget>[
          GlobalText(
            background: Colors.white,
            margin: 0,
            padding: 5,
            alignment: Alignment.centerLeft,
            imgHeight: double.maxFinite,
            imgWidth: double.maxFinite,
            imgUrl: imgUrl,
            radius: 10,
            imgPlaceholder: imgPlaceholder,
          ),
          floating.isNotEmpty
              ? GlobalText(
                  alignment: Alignment(1, -1),
                  textTitle: floating,
                  padding: 5,
                  background: Colors.white,
                  radius: 50,
                  textAlign: TextAlign.center,
                )
              : SizedBox(),
          Material(
            color: Config.colorTransparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: callback,
            ),
          ),
        ],
      ),
    );
  }
}
