import 'package:flutter/material.dart';
import '../util/util.dart';
import '../util/pref.dart';

class GlobalSlides {
  Util util = Util();
  Pref pref = Pref();

  Widget slideOne(
      {height: 120.0,
      width: 200.0,
      radius = 10.0,
      img: "",
      name: "",
      nameSize: 18.0,
      nameOpacity: 0.9,
      nameColor: Colors.white,
      nameX: -0.7,
      nameY: 0.8,
      price: "",
      priceRadius: false,
      priceSize: 15.0,
      priceX: 0.8,
      priceY: -0.8,
      gradient: false,
      int gradienC1: 0xFFFFFFFF,
      int gradienC2: 0XFF333333,
      double gadrientOp1: 0.0,
      double gadrientOp2: 0.7,
      evt()}) {
    final content = Container(
      height: height,
      width: width,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: FadeInImage(
              height: height,
              width: width,
              placeholder: AssetImage("assets/img/place_product.png"),
              image: NetworkImage(img),
              fit: BoxFit.cover,
            ),
          ),
          price != ""
              ? Align(
                  alignment: Alignment(priceX, priceY),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "${pref.stg_coin}${price.toStringAsFixed(2)}",
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      style: TextStyle(
                          fontSize: priceSize, fontWeight: FontWeight.w900),
                    ),
                  ),
                )
              : SizedBox(),
          gradient
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    ),
                    gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Color(gradienC1).withOpacity(gadrientOp1),
                          Color(gradienC2).withOpacity(gadrientOp2),
                        ],
                        stops: [
                          0.0,
                          1.0
                        ]),
                  ),
                )
              : SizedBox(),
          name != ""
              ? Align(
                  alignment: Alignment(nameX, nameY),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: Opacity(
                      opacity: nameOpacity,
                      child: Text(
                        "${name}",
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                            fontSize: nameSize,
                            color: nameColor,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        content,
        Container(
          height: height,
          width: width,
          child: Material(
            color: Color(0000000000),
            child: Container(
              child: InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: evt,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
