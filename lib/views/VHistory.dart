import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../util/pref.dart';
import '../util/util.dart';
import '../widgets/modal.dart';
import '../beans/history.dart';
import '../views/VHistoryDetail.dart';

class VHistory extends StatefulWidget {
  @override
  _VHistoryState createState() => _VHistoryState();
}

class _VHistoryState extends State<VHistory> {
  final _refresh = GlobalKey<RefreshIndicatorState>();
  Util  _util  = Util();
  Pref  _pref  = Pref();
  Modal _modal = Modal();
  bool _loading = true;
  Map   _rsp;

  List<History> _orders = [];
  List<Widget> _listOrders = List();

  Future _getOrders() async{
    try{
      _orders = [];
      setState(()=>_loading = true);
      http.Response response = await http.post(
          "${_util.BASE_URL}/orders/history",
          body: ({"token": "${_pref.client_token}"})
      );
      _rsp = jsonDecode(response.body);
      if(_rsp['ok']){
        for(int i=0; i < _rsp["items"].length; i++){
          History item = History();
          item.id = int.parse(_rsp["items"][i]["id"]);
          item.method = _rsp["items"][i]["method"];
          item.price_total = double.parse(_rsp["items"][i]["price_total"]);
          item.cost_shipping = double.parse(_rsp["items"][i]["cost_shipping"]);
          item.delivery_date = DateTime.parse(_rsp["items"][i]["delivery_date"]);
          item.address = _rsp["items"][i]["address"];
          item.date_created = DateTime.parse(_rsp["items"][i]["date_created"]);
          item.state = int.parse(_rsp["items"][i]["state"]);
          item.order = _rsp["items"][i]["order"];
          _orders.add(item);
        }
        _fillOrders();
      }else{
        _modal.show(context, "Ups...", "Ocurrio un error.");
      }
      setState(()=>_loading = false);
    }catch(e){
      setState(()=>_loading = false);
      _modal.show(context, "Ups...", "No tienes conectividad.");
    }
  }

  void _fillOrders(){
    _listOrders = [];
    _orders.forEach((item){

      String stateOrder = "";
      if(item.state == 1){
        stateOrder = "PENDIENTE";
      }else if(item.state == 2){
        stateOrder = "COMPLETADO";
      }else{
        stateOrder = "ANULADO";
      }

      _listOrders.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                "${DateFormat.yMMMMd("es_ES").format(item.date_created)}",
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
              subtitle: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                    decoration: BoxDecoration(
                      color: item.state == 0 ? Color(_util.rosado) :
                      item.state == 1 ? Color(_util.ambar) : Color(_util.greenPrimary),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Text(
                      stateOrder,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Text(
                "S/${(item.price_total + item.cost_shipping).toStringAsFixed(2)}",
              ),
              onTap: ()=>openDetail(item),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Divider(height: 0.0),
            ),
          ],
        ),
      );
    });
  }

  void openDetail(History item){
    Navigator.push(context, MaterialPageRoute(builder: (context) => VHistoryDetail(item)));
  }

  Future<Null> loadData() {
    return  _getOrders().then((rsp){
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _pref.init().then((value){setState(() {_pref = value;});});
    initializeDateFormatting("es_ES", null).then((_){});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refresh.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {

    final ordersView =  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _listOrders,
    );

    final emptyOrders = Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(
                Icons.error_outline,
                size: 70.0,
                color: Color(_util.texto),
              ),
            ),
            Container(
              child: Text(
                "Aun no tienes pedidos",
                style: TextStyle(
                  fontSize: 25.0,
                  color: Color(_util.texto),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'FrancoisOne',
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(_util.primaryColor),
          title: Text("Mis pedidos"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white),
            onPressed: ()=>Navigator.pop(context),
          ),
        ),
        body: RefreshIndicator(
          key: _refresh,
          onRefresh: loadData,
          child: _orders.length > 0 ? ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              ordersView
            ],
          ) : !_loading ? emptyOrders : ListView(),
        ),
      ),
    );
  }
}
