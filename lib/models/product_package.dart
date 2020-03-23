import 'package:flutter/material.dart';
import '../beans/product.dart';
import '../util/util.dart';

class ModelProductPackage extends StatelessWidget {
  Product product;

  ModelProductPackage(this.product);

  Util _util = Util();

  @override
  Widget build(BuildContext context) {
    final productPic = Container(
      height: 60.0,
      width: 60.0,
      child: FadeInImage.assetNetwork(
        image: product.pics.length > 0 ? product.pics[0].pic_large : "",
        placeholder: 'assets/img/kake.png',
        fit: BoxFit.cover,
        height: 60.0,
        width: 60.0,
      ),
    );

    final productDetail = Container(
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
                child: Text(product.name,
                    style: TextStyle(
                        color: Color(_util.blackPrimary),
                        fontFamily: 'Geomanist',
                        fontWeight: FontWeight.w900,
                        fontSize: 20.0),
                    textAlign: TextAlign.left),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                    child: Text(
                      "s/ ${product.price}",
                      style: TextStyle(
                        color: Color(_util.blackPrimary),
                        fontSize: 20.0,
                        fontFamily: 'Geomanist',
                        // fontWeight: FontWeight.w900,
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
                  product.description.length < 36
                      ? product.description
                      : "${product.description.substring(0, 30)}...",
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
          // Container(
          //     child: Icon(Icons.keyboard_arrow_right,size: 25.0,color: Color(_util.blackPrimary)),
          // ),
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
}
