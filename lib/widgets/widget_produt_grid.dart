import 'package:flutter/material.dart';
import '../util/Config.dart';
import 'global_text.dart';

class WidgetProductGrid extends StatelessWidget {
  final Color colorOne;
  final Color colorTwo;
  IconData icon;
  String imgUrl;
  String imgPlaceholder;
  String title;
  String description;
  String floating;
  VoidCallback callback;

  WidgetProductGrid({
    Key kek,
    @required this.colorOne,
    @required this.colorTwo,
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

    print("Tamaño de pantalla: ${MediaQuery.of(context).size.width}");
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 125,
      width: (MediaQuery.of(context).size.width / 3) - 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFDFDFDF).withOpacity(0.3),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(
              0,
              0.6,
            ),
          )
        ],
      ),
      child: Stack(
        children: <Widget>[
          GlobalText(
            background: Colors.white,
            margin: 0,
            alignment: Alignment.centerLeft,
            imgHeight: double.maxFinite,
            imgWidth: double.maxFinite,
            imgUrl: imgUrl,
            radius: 10,
            imgPlaceholder: imgPlaceholder,
          ),
          Align(
            alignment: Alignment(-1, 1),
            child: Container(
              height: 70.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GlobalText(
                    marginTop: 15,
                    marginBottom: 0,
                    alignment: Alignment.centerLeft,
                    textTitle: title,
                    textFontWeight: FontWeight.w900,
                    textColor: Colors.white,
                  ),
                  GlobalText(
                    marginTop: 0,
                    alignment: Alignment.centerLeft,
                    textTitle: description,
                    textFontWeight: FontWeight.w300,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
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
              splashColor: colorTwo.withOpacity(0.7),
              onTap: callback,
            ),
          ),
        ],
      ),
    );
  }
}
