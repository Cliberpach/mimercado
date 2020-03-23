import 'package:flutter/material.dart';
import '../beans/carrito.dart';
import '../util/util.dart';


class ModelProductCarShop extends StatelessWidget {
    Carrito item;
    double priceItem;
    ModelProductCarShop(this.item,this.priceItem);
    Util _util = Util();

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            width: (MediaQuery.of(context).size.width - 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Container(
                        height: 70.0,
                        width: 70.0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: FadeInImage(
                                placeholder: AssetImage("assets/img/kake.png"),
                                image: NetworkImage(item.pic_selected),
                                fit: BoxFit.cover,
                            ),
                        ),
                    ),
                    Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  height: 20.0,
                                  width: (MediaQuery.of(context).size.width - 110.0),
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text(
                                      item.name.length <= 40
                                          ? item.name : "${item.name.substring(0,37)}...",
                                      style: TextStyle(
//                                          fontFamily: 'FrancoisOne',
                                          fontSize: 17.0,
                                      ),
                                  ),
                              ),
                              Container(
                                height: 30.0,
                                width: (MediaQuery.of(context).size.width - 110.0),
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Icon(
                                        Icons.grid_on,
                                        color: item.type == "product"
                                            ? Color(_util.primaryColor)
                                            : Color(_util.greenAccent),
                                        size: 13.0
                                      ),
                                    ),
                                    SizedBox(width: 3.0),
                                    Container(
                                      child: Text(
                                        "${item.quantity} Unidades${item.extras.length > 0 ? ", +${item.extras.length} Extras" : ""}" ,
                                        style: TextStyle(
                                            color: Color(_util.texto),
                                            fontSize: 13.0
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 20.0,
                                width: (MediaQuery.of(context).size.width - 110.0),
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: item.type == "product"
                                            ? Color(_util.primaryColor)
                                            : Color(_util.greenAccent),
                                      ),
                                      child: Text(
                                        "S/.${priceItem.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color: Colors.white,
//                                          fontFamily: 'FrancoisOne',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}