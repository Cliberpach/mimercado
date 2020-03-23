import 'package:anvic/util/Config.dart';
import 'package:flutter/material.dart';
import 'global_text.dart';

class WidgetCategory extends StatelessWidget {
  IconData icon;
  String imgUrl;
  String imgPlaceholder;
  String title;
  String description;
  String floating;
  VoidCallback callback;

  WidgetCategory({
    Key key,
    this.icon,
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
      height: 155,
      width: 100,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 15, right: 15, left: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                icon != null
                    ? GlobalText(
                        margin: 0,
                        alignment: Alignment.centerLeft,
                        icon: Icon(
                          icon,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    : GlobalText(
                        margin: 0,
                        radius: 35,
                        alignment: Alignment.centerLeft,
                        imgHeight: 70,
                        imgWidth: 70.0,
                        imgUrl: imgUrl,
                        imgPlaceholder: imgPlaceholder,
                      ),
                GlobalText(
                  marginTop: 10,
                  marginRight: 0,
                  marginBottom: 0,
                  marginLeft: 0,
                  alignment: Alignment.centerLeft,
                  textTitle: title,
                  textSoftWrap: true,
                  textMaxLines: 2,
                  textOverflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
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
