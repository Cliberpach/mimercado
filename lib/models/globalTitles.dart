import 'package:flutter/material.dart';

class GlobalTitles {

  Widget titleOne(
      {color,
      t1: "",
      s1: 30.0,
      c1,
      t2: "",
      s2: 30.0,
      c2,
      t3: "",
      s3: 20.0,
      c3,
      evt()}) {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Center(
                  child: Text(
                    "${t1}",
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: s1,
                      color: c1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  "${t2}",
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: s2,
                    color: c2,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          Material(
            color: Color(0000000000),
            child: InkWell(
              child: Text(
                "${t3}",
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  fontSize: s3,
                  color: c3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: evt,
            ),
          )
        ],
      ),
    );
  }

}
