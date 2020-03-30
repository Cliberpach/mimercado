import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:async';
import '../beans/point.dart';
import '../util/pref.dart';
import 'dart:convert';
import '../util/pref.dart';
import '../widgets/modal.dart';
import '../util/util.dart';
class VAddPoint extends StatefulWidget {
  @override
  _VAddPointState createState() => _VAddPointState();
}

class _VAddPointState extends State<VAddPoint> {
  GoogleMapController mapController;

  LatLng mapCenter = LatLng(0, 0);
  bool _loading = false;
  Util _util = Util();
  Pref _pref = Pref();
  Modal _modal = Modal();
  Map _rsp;
  Point _point = Point(0, 0);
  List<Widget> _listComplete = List();

  var _ctAddress = TextEditingController();

  void detectCurrentLocation() {
    setState(() {
      mapCenter = LatLng(double.parse(_pref.client_lat), double.parse(_pref.client_lng));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future _moveCamera(id) async{
    setState(() {_listComplete = [];});
    FocusScope.of(context).requestFocus(new FocusNode());
    print(_pref.client_token);
    print(id);
    try{
      http.Response response = await http.post(
        "${_util.BASE_URL}/map/place",
        body: ({"token": "${_pref.client_token}","id": "${id}"})
      );

      _rsp = jsonDecode(response.body);
      if(_rsp['ok']){
        _point = Point(_rsp['lat'],_rsp['lng']);
        _point.address = _rsp['address'];

        print(_point.lat.toString() + _point.lng.toString() + _point.address);

        setState(() {
          mapCenter = _point.toLatLng();
          _ctAddress.text = _point.address;
        });

        mapController.moveCamera(
          CameraUpdate.newLatLng(mapCenter),
        );
      }
    }catch(e){
      print("Error _moveCamera: $e");
    }
  }

  Future _query(q) async{
    setState(() {
      _loading = true;
    });
    try{
      print(_pref.client_token);
      print(q);
      print(mapCenter.latitude);
      print(mapCenter.longitude);
      http.Response response = await http.post(
        "${_util.BASE_URL}/map/autocomplete",
        body: ({
          "token": "${_pref.client_token}",
          "query": "${q}",
          "lat": "${mapCenter.latitude}",
          "lng": "${mapCenter.longitude}"
        })
      );
      _rsp = jsonDecode(response.body);
      if(_rsp['ok']){
        _listComplete = [];
        if(_rsp['items'].length > 0){
          _rsp['items'].forEach((p){
            _listComplete.add(
              InkWell(
                splashColor: Color(_util.colorUno),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    width: MediaQuery.of(context).size.width - 20.0,
                                    child: Text(
                                      "${p['address']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 0.0),
                  ],
                ),
                onTap: ()=>_moveCamera(p['id']),
              ),
            );
          });
        }else{
          _listComplete.add(
            Container(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                    "No hay resultados.",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            )
          );
        }
      }
      setState(() {
        _loading = false;
      });
    }catch(e){
      setState(() {
        _loading = false;
        _listComplete = [];
      });
      _modal.show(context, "Error", "No tienes conectividad");
    }
  }

  Future _saveAddress() async {
    if(_point.address != '' && _point.lat != 0){
      setState(()=>_loading = true);
      try{
        http.Response response = await http.post(
            "${_util.BASE_URL}/client_points/create",
            body: ({
              "token": "${_pref.client_token}",
              "lat": "${_point.lat}",
              "lng": "${_point.lng}",
              "address": "${_point.address}",
            })
        );
        _rsp = jsonDecode(response.body);
        if(_rsp['ok']){
          _modal.toast("Dirección agregada");
          Navigator.pop(context);
        }else{
          _modal.show(context, "Ups...", "Ocurrio un error.");
        }
      }catch(e){
        setState(()=>_loading = false);
        _modal.show(context, "Ups...", "No tienes conectividad.");
      }
    }else{
      _modal.show(context, "Espera", "Ingresa un dirección.");
    }
  }

  @override
  void initState() {
    super.initState();
    detectCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    //aqui busca la direccion y no sale hame hame
    final search = Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Color(_util.colorDos),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextField(
              controller: _ctAddress,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Dirección',
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(_util.colorDos),width: 3.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(_util.colorTres), width: 3.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              style: TextStyle(
                color: Color(_util.colorTres),
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
              onChanged: (q)=>_query(q),//yo creo k este es k me lleva al ladrireccion
            ),
          )
        ],
      ),
    );

    final completeView = ConstrainedBox(
      constraints: new BoxConstraints(
        minWidth: MediaQuery.of(context).size.width - 0.0,
        maxWidth: MediaQuery.of(context).size.width - 0.0,
        minHeight: 50.0,
        maxHeight: 300.0,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(_util.shadow),
                offset: Offset(0.0, 3.0),
                blurRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.circular(5.0)
        ),
        margin: EdgeInsets.fromLTRB(0, 67, 0, 0),
        child: Material(
          color: Colors.white,
          child: Container(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _listComplete,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final loading = Container(
      width: MediaQuery.of(context).size.width - 0.0,
      height: MediaQuery.of(context).size.height - 50.0,
      color: Color(0x91000000),
      margin: EdgeInsets.fromLTRB(0, 67, 0, 0),
      child: Center(
        child: SizedBox(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(_util.colorDos)),
              strokeWidth: 5.0
          ),
          height: 25.0,
          width: 25.0,
        ),
      ),
    );

    final btnListo = Positioned(
      bottom: 10.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _saveAddress,
              color: Color(_util.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(100.0)),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
              textColor: Colors.white,
              child: Text(
                "Listo",
                style: TextStyle(fontSize: 17.0),
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
          title: Text("Agregar dirección"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pop(context);
              print("se va a direccion");
            },
          ),
        ),
        body: mapCenter != LatLng(0,0) ? Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: mapCenter,
                zoom: 18.0,
              ),
              onCameraMove: (_){
                setState((){
                  _point.lat = _.target.latitude;
                  _point.lng = _.target.longitude;
                });
              },
            ),
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 43),
                child: Icon(Icons.place, color: Colors.red, size: 50.0),
              ),
            ),
            search,
            btnListo,
            _loading ? loading : _listComplete.length > 0 ? completeView : SizedBox(height: 0.0),
          ],
        ) : Center(
          child: SizedBox(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(_util.colorDos)),
                strokeWidth: 5.0
            ),
            height: 25.0,
            width: 25.0,
          ),
        ),
      ),
    );
  }
}