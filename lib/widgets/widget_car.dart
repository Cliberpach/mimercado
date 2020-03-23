import 'package:flutter/material.dart';
import '../util/util.dart';

class WidgetCar{
    Util _util = Util();

    Widget carShop(context,quantity,price,openCarShop) {
        return Positioned(
            bottom: 0.0,
            left: 0.0,
            child: Material(
                color: Color(_util.primaryColor),
                borderRadius: BorderRadius.circular(0.0),
                child: Container(
                    width: (MediaQuery.of(context).size.width - 0),
                    height: 50.0,
                    child: InkWell(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                                Container(                                    
                                    height: 30.0,
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),
                                    child: Center(
                                      child: Text(
                                          "${quantity}",
                                          style: TextStyle(
                                              color: Colors.white,
//                                              fontFamily: 'FrancoisOne',
                                              fontSize: 20.0
                                          ),
                                      ),
                                    ),
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text(
                                        "Ver canasta",
                                        style: TextStyle(
                                            color: Colors.white,
//                                            fontFamily: 'FrancoisOne',
                                            fontSize: 20.0
                                        ),
                                    ),
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Text(
                                        "S/.${price.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            color: Colors.white,
//                                            fontFamily: 'FrancoisOne',
                                            fontSize: 20.0
                                        ),
                                    ),
                                ),
                            ],
                        ),
                        onTap: openCarShop,
                    )
                ),
            ),
        );
    }


    Widget carShopfx(context,quantity,price,openCarShop){
        return Positioned(
            bottom: 0.0,
            child: InkWell(
              onTap: openCarShop,
              child: Container(
                  width: (MediaQuery.of(context).size.width - 20.0),
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),  
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      color: Color(_util.greenPrimary)
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Color(_util.rosado),
                              ),
                              child: Text(
                                  quantity.toString(),
                                  style: TextStyle(
                                      fontSize: 20.0,  
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                  ),
                              ),  
                          ),
                          Container(
                            child: Text(
                              "Ver canasta",
                              style: TextStyle(
                                fontSize: 18.0, 
                                color: Colors.white,
                              ),
                            ),  
                          ),
                          Container(
                              child: Text(
                                  "S/ ${price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontSize: 18.0,  
                                      color: Colors.white,
                                  ),
                              ),                            
                          ),
                      ],
                  ),
              ),
            ),
        );
    }











    Widget buttonFooter(context,text,color,openPayment){  
        return Positioned(
            bottom: -6.0,
            child: ButtonTheme(
                    minWidth: (MediaQuery.of(context).size.width), 
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0)),
                    child: RaisedButton(
                        color: Color(color), 
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20), 
                        child: Text( 
                            text,
                            style: TextStyle( 
                                fontSize: 20.0, 
                                color: Colors.white, 
                                fontFamily: 'Geomanist',
                                fontWeight: FontWeight.bold  
                            ),
                        ),
                        onPressed: ()=>openPayment(),
                    ),
                ),
        );
    }
}