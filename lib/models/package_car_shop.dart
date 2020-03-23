/*
import 'package:flutter/material.dart';
import '../beans/package.dart';
import '../util/util.dart';

class ModelPackageCarShop extends StatelessWidget {
    Package package;
    int quantity;
    double price;
    ModelPackageCarShop(this.package,this.quantity,this.price);
    Util _util = Util();

    @override
    Widget build(BuildContext context) {

        final productPic = Container(
            height: 60.0,
            width: 60.0,
            child: FadeInImage.assetNetwork(
                image: package.pic_small,
                placeholder: 'assets/img/kake.png',
                fit: BoxFit.cover,
                height: 60.0,
                width: 60.0,
            ),
        );

        final productDetail= Container(
            width: (MediaQuery.of(context).size.width - 80.0),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: Text(
                                    package.name,
                                    style: TextStyle(
                                        color: Color(_util.blackPrimary),
                                        fontFamily: 'Geomanist',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20.0
                                    ),
                                    textAlign: TextAlign.left
                                ),
                            ),
                            Row(
                                children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            color: Color(_util.pinkPrimary),
                                        ),
                                        child: Text(
                                            "${quantity}",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white,
                                            ),
                                            textAlign: TextAlign.left,
                                        ),
                                    ),
                                    Container(
                                        padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                        child: Text(
                                            "s/ ${price.toStringAsFixed(2)}",
                                            style: TextStyle(
                                                color: Color(_util.blackPrimary),
                                                fontSize: 20.0,
                                                fontFamily: 'Geomanist',
                                            ),
                                            textAlign: TextAlign.left,
                                        ),
                                    ),
                                ],
                            ),
                            Container(
                                width: (MediaQuery.of(context).size.width - 150.0),
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: Text(
                                    package.description.length < 36
                                    ? package.description
                                    : "${package.description.substring(0,30)}...",
                                    style: TextStyle(
                                        color: Color(_util.blackPrimary),
                                        fontSize: 15.0,
                                        fontFamily: 'Geomanist',
                                    ),
                                    textAlign: TextAlign.left,
                                ),
                            ),
                        ],
                    ),
                    Container(
                        child: Icon(Icons.keyboard_arrow_right,size: 25.0,color: Color(_util.blackPrimary)),
                    ),
                ],
            ),

        );

        return Container(
            margin: EdgeInsets.all(5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    productPic,
                    productDetail,
                ],
            ),
        );
    }
}*/
