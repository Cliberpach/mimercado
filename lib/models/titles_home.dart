import 'package:flutter/material.dart';
import '../util/util.dart';

class Titles{
    Util  _util  = Util();
    Widget titleHome(t1,t2,t3,evt){
        return Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                            Container(
                                child: Text(
                                    "${t1}",
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
//                                        fontFamily: 'FrancoisOne',
                                    ),
                                ),
                            ),
                            SizedBox(width: 5.0),
                            Container(
                                child: Text(
                                    "${t2}",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Color(_util.texto),
//                                        fontFamily: 'FrancoisOne',
                                    ),
                                ),
                            ),
                        ],
                    ),
                    evt != null ? InkWell(
                        child:  Row(
                            children: <Widget>[
                                Container(
                                    child: Text(
                                        "${t3}",
                                        style: TextStyle(
                                            color: Color(_util.rosado),
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
//                                            fontFamily: 'FrancoisOne',
                                        ),
                                    ),
                                ),
                                Container(
                                    child: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Color(_util.rosado)
                                    ),
                                ),
                            ],
                        ),
                        onTap: evt,
                    ) : SizedBox(height: 0.0),
                ],
            ),
        );
    }
}