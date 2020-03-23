import 'package:flutter/material.dart';

class GlobalButtons {
  Widget buttonOne({
    evt(),
    loading: false,
    title = '',
    int colorButton: 0xFF99C6F6,
    int textColor: 0xFFFFFFFF,
    fontSize: 22.0,
    fontFamily,
    progress: 20.0,
    proStroke: 2.0,
    proColor: 0xFFFFFFFF,
    minWidth: double.maxFinite,
    double margin: null,
    double marginTop: 10.0,
    double marginRigth: 10.0,
    double marginBottom: 10.0,
    double marginLeft: 10.0,
    double borderRadius: null,
    double topRight: 30.0,
    double topLeft: 30.0,
    double bottomRight: 30.0,
    double bottomLeft: 30.0,
    double paddingX: 15.0,
    double paddingY: 15.0,
  }) {
    return Container(
      padding: margin != null
          ? EdgeInsets.all(margin)
          : EdgeInsets.fromLTRB(
              marginLeft, marginTop, marginRigth, marginBottom),
      child: ButtonTheme(
        minWidth: minWidth,
        shape: RoundedRectangleBorder(
            borderRadius: borderRadius != null
                ? BorderRadius.circular(borderRadius)
                : BorderRadius.only(
                    topRight: Radius.circular(topRight),
                    topLeft: Radius.circular(topLeft),
                    bottomRight: Radius.circular(bottomRight),
                    bottomLeft: Radius.circular(bottomLeft))),
        child: RaisedButton(
          onPressed: !loading ? evt : () {},
          color: Color(colorButton),
          padding: EdgeInsets.fromLTRB(paddingX, paddingY, paddingX, paddingY),
          child: !loading
              ? Text("${title}",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: fontFamily,
                    color: Color(textColor),
                  ))
              : SizedBox(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(proColor)),
                      strokeWidth: proStroke),
                  height: progress,
                  width: progress,
                ),
        ),
      ),
    );
  }

  Widget buttonTwo(
    context, {
    evt(),
    loading: false,
    title = '',
    int colorButton: 0xFF99C6F6,
    int textColor: 0xFFFFFFFF,
    fontSize: 22.0,
    fontFamily,
    progress: 20.0,
    proStroke: 2.0,
    proColor: 0xFFFFFFFF,
    minWidth: double.maxFinite,
    double margin: null,
    double marginTop: 10.0,
    double marginRigth: 10.0,
    double marginBottom: 10.0,
    double marginLeft: 10.0,
    double borderRadius: null,
    double topRight: 30.0,
    double topLeft: 30.0,
    double bottomRight: 30.0,
    double bottomLeft: 30.0,
    double paddingX: 15.0,
    double paddingY: 15.0,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          padding: margin != null
              ? EdgeInsets.all(margin)
              : EdgeInsets.fromLTRB(
                  marginLeft, marginTop, marginRigth, marginBottom),
          child: ButtonTheme(
            minWidth: minWidth,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius != null
                    ? BorderRadius.circular(borderRadius)
                    : BorderRadius.only(
                        topRight: Radius.circular(topRight),
                        topLeft: Radius.circular(topLeft),
                        bottomRight: Radius.circular(bottomRight),
                        bottomLeft: Radius.circular(bottomLeft))),
            child: RaisedButton(
              onPressed: !loading ? evt : () {},
              color: Color(colorButton),
              padding:
                  EdgeInsets.fromLTRB(paddingX, paddingY, paddingX, paddingY),
              child: !loading
                  ? Text("${title}",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                        color: Color(textColor),
                      ))
                  : SizedBox(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Color(proColor)),
                          strokeWidth: proStroke),
                      height: progress,
                      width: progress,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
