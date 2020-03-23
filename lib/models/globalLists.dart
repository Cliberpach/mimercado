import 'package:flutter/material.dart';

class GlobalLists {
  Widget listOne(
      {padding: null,
      paddingLeft: 10.0,
      paddingTop: 10.0,
      paddingRight: 10.0,
      paddingBottom: 10.0,
      title: "",
      overflow: TextOverflow.fade,
      softWrap: true,
      int textColor: 0xFF000000,
      fontFamily,
      fontSize: 18.0,
      fontWeight}) {
    return Container(
      padding: padding != null
          ? EdgeInsets.all(padding)
          : EdgeInsets.fromLTRB(
              paddingLeft, paddingTop, paddingRight, paddingBottom),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text("${title}",
                overflow: overflow,
                softWrap: softWrap,
                style: TextStyle(
                    color: Color(textColor),
                    fontFamily: fontFamily,
                    fontSize: fontSize,
                    fontWeight: fontWeight)),
          ),
        ],
      ),
    );
  }
}
