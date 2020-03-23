import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../util/pref.dart';
import '../util/util.dart';
import '../widgets/modal.dart';
import '../beans/history.dart';

class VHistoryDetail extends StatefulWidget {
  History item;
  VHistoryDetail(this.item);
  @override
  _VHistoryDetailState createState() => _VHistoryDetailState(item);
}

class _VHistoryDetailState extends State<VHistoryDetail> {
  History item;
  _VHistoryDetailState(this.item);

  Util  _util  = Util();
  Pref  _pref  = Pref();
  List<Widget> _listOrders = List();
  String stateOrder = "";

  void _fillOrder() {
    _listOrders = [];
    item.order.asMap().forEach((index, order){
      _listOrders.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: FadeInImage(
                height: 60.0,
                width: 60.0,
                placeholder: AssetImage("assets/img/kake.png"),
                image: NetworkImage(order["pic_large"]),
                fit: BoxFit.cover,
              ),
              title: Text("${order["name"]}"),
              subtitle: Text(
                order["type"] == "product"  ? "Producto" : "Paquete",
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Divider(height: 0.0),
            ),
          ],
        ),
      );
    });
  }

  stateRequested(){
    if(item.state == 1){
      stateOrder = "PENDIENTE";
    }else if(item.state == 2){
      stateOrder = "COMPLETADO";
    }else{
      stateOrder = "ANULADO";
    }
  }

  @override
  void initState() {
    super.initState();
    _pref.init().then((value){setState(() {_pref = value;});});

    stateRequested();
  }

  @override
  Widget build(BuildContext context) {
    _fillOrder();



    final state = Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
            color: item.state == 1 ? Color(_util.ambar)
                : item.state == 2 ? Color(_util.greenPrimary)
                : Color(_util.rosado),
            borderRadius: BorderRadius.circular(50.0)
          ),
          child: Center(
            child: Text(
              stateOrder,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white
              ),
            ),
          ),
        )
      ],
    );

    final detail = Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 25.0,
                  child: Icon(
                    Icons.place,
                    size: 15.0,
                    color: Color(_util.ambar),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Dirección",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      width: MediaQuery.of(context).size.width - 65.0,
                      child: Text(
                        item.address,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Color(_util.texto)
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 25.0,
                  child: Icon(
                    Icons.local_offer,
                    size: 15.0,
                    color: Color(_util.greenPrimary),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Precio",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Text(
                            "S/.${(item.price_total).toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(_util.texto)
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Envío",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Text(
                            "S/.${(item.cost_shipping).toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(_util.texto)
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Total",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Text(
                            "S/${(item.price_total + item.cost_shipping).toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(_util.texto)
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Método",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Text(
                            "${item.method}",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(_util.texto)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 25.0,
                  child: Icon(
                    Icons.date_range,
                    size: 15.0,
                    color: Color(_util.ambar),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Fecha de envío",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      width: MediaQuery.of(context).size.width - 65.0,
                      child: Text(
                        "${DateFormat.yMMMMd("es_ES").format(item.delivery_date)} ${DateFormat.jm().format(item.delivery_date)}",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Color(_util.texto)
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );

    final orderView =  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _listOrders,
    );

    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(_util.primaryColor),
          title: Text("${DateFormat.yMMMMd("es_ES").format(item.date_created)}"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white),
            onPressed: ()=>Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                SizedBox(height: 10.0),
                state,
                SizedBox(height: 10.0),
                detail,
                SizedBox(height: 10.0),
                orderView
              ],
            )
          ],
        )
      ),
    );
  }
}
