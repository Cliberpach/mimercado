import 'package:flutter/material.dart';
import '../util/util.dart';

class GlobalTexts {
  Widget textOne(
      {int color: 0000000000,
      padding: null,
      paddingLeft: 10.0,
      paddingTop: 10.0,
      paddingRight: 10.0,
      paddingBottom: 10.0,
      margin: null,
      marginLeft: 0.0,
      marginTop: 0.0,
      marginRight: 0.0,
      marginBottom: 0.0,
      radius: null,
      topLeft: 0.0,
      topRight: 0.0,
      bottomLeft: 0.0,
      bottomRight: 0.0,
      icon: null,
      iconColor: 0xFFDFDFDF,
      iconSize: 25.0,
      title: "",
      overflow: TextOverflow.fade,
      softWrap: true,
      maxLines,
      int textColor: 0xFF000000,
      fontFamily,
      fontSize: 18.0,
      fontWeight,
      textAlign,
      evt(),
      evtX = 0.0,
      evtY = 0.0}) {
    return Container(
      padding: padding != null
          ? EdgeInsets.all(padding)
          : EdgeInsets.fromLTRB(
              paddingLeft, paddingTop, paddingRight, paddingBottom),
      margin: margin != null
          ? EdgeInsets.all(margin)
          : EdgeInsets.fromLTRB(
              marginLeft, marginTop, marginRight, marginBottom),
      decoration: BoxDecoration(
          color: Color(color),
          borderRadius: radius != null
              ? BorderRadius.circular(radius)
              : BorderRadius.only(
                  topLeft: Radius.circular(topLeft),
                  topRight: Radius.circular(topRight),
                  bottomLeft: Radius.circular(bottomLeft),
                  bottomRight: Radius.circular(bottomRight),
                )),
      child: InkWell(
        child: icon != null
            ? Container(
                padding: evt != null
                    ? EdgeInsets.fromLTRB(evtX, evtY, evtX, evtY)
                    : EdgeInsets.all(0),
                child: Icon(icon, color: Color(iconColor), size: iconSize),
              )
            : Text("${title}",
                overflow: overflow,
                softWrap: softWrap,
                maxLines: maxLines,
                textAlign: textAlign,
                style: TextStyle(
                    color: Color(textColor),
                    fontFamily: fontFamily,
                    fontSize: fontSize,
                    fontWeight: fontWeight)),
        borderRadius: radius != null
            ? BorderRadius.circular(radius)
            : BorderRadius.only(
                topLeft: Radius.circular(topLeft),
                topRight: Radius.circular(topRight),
                bottomLeft: Radius.circular(bottomLeft),
                bottomRight: Radius.circular(bottomRight),
              ),
        onTap: evt != null ? () => evt() : null,
      ),
    );
  }
}
