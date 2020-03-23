import 'package:anvic/beans/success.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import '../models/globalTextField.dart';
import '../models/globalButtons.dart';
import '../models/globalAlerts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'dart:convert';
import '../util/pref.dart';
import '../util/util.dart';
import '../beans/carrito.dart';
import '../beans/point.dart';
import '../beans/order.dart';
import '../widgets/modal.dart';
import 'VAddCreditCard.dart';
import 'VSuccess.dart';
import 'VAddress.dart';

class VPayment extends StatefulWidget {
  List<Carrito> listCarrito;

  VPayment(this.listCarrito);

  // ******************************************
  @override
  _VPaymentState createState() => _VPaymentState(listCarrito);
}

class _VPaymentState extends State<VPayment> {
  List<Carrito> listCarrito;

  _VPaymentState(this.listCarrito);

  // ******************************************
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GloblaTextField globalTextFild = GloblaTextField();
  GlobalButtons globalButtons = GlobalButtons();
  GlobalAlerts globalAlerts = GlobalAlerts();

  Util _util = Util();
  Pref _pref = Pref();
  Modal _modal = Modal();
  Map _rsp;
  Order _order = Order();
  int _method = 1;
  Point _point = Point(0, 0);
  bool _loading = false;

  double _priceTotal = 0.0;
  double _delivery = 0.0;

  //  ************************************
  int _timeLimit = 7;
  bool programado = false;
  String _deliveryDate;
  String _deliveryTime;
  String _deliveryDateText;
  String _deliveryTimeText;
  String pickerDate;
  String pickerTime;

  //  ************************************

  void loadData() {
    setState(() {
      _priceTotal = 0.0;
    });

    listCarrito.forEach((item) {
      _priceTotal = _priceTotal + (item.quantity * item.price);

      item.extras.forEach((extra) {
        _priceTotal = _priceTotal + (extra.quantity * extra.price);
      });
    });

    if (listCarrito.length <= 0) {
      Navigator.pop(context, listCarrito);
    } else {
      _order.items = [];
      listCarrito.forEach((item) {
        _order.items.add(item.toJson());
      });
    }

    DateTime hoy = DateTime.now();
    String year, month, day;
    year = hoy.year.toString();
    month = hoy.month <= 9 ? "0${hoy.month}" : "${hoy.month}";
    day = hoy.day <= 9 ? "0${hoy.day}" : "${hoy.day}";
    _deliveryDate = "${year}-${month}-${day}";
    _deliveryDateText = DateFormat.yMMMMd("es_ES").format(hoy);
    _deliveryTime = DateFormat.Hm().format(hoy);
    _deliveryTimeText = DateFormat.jm().format(hoy);

    print(_deliveryTime);

    var hh = [];
    var mm = [];
    var tt = ['"AM"', '"PM"'];

    for (int i = 1; i <= 12; i++) {
      i <= 9 ? hh.add('"0${i}"') : hh.add('"${i}"');
    }

    for (int i = 0; i <= 59; i++) {
      i <= 9 ? mm.add('"0${i}"') : mm.add('"${i}"');
    }

    pickerTime = '''[$hh,$mm,$tt]''';

    List<DateTime> listAvailableDates = [];
    var years = [];
    var now = DateTime.now();
    for (int i = 0; i <= _timeLimit; i++) {
      var newDate = now.add(Duration(days: i));
      listAvailableDates.add(newDate);
      if (!years.contains(newDate.year)) {
        years.add(newDate.year);
      }
    }

    var datos = [];
    years.forEach((year) {
      var months = [];
      listAvailableDates.forEach((item) {
        if (item.year == year && !months.contains(item.month)) {
          months.add(item.month);
        }
      });

      String dato = """{"$year": [""";

      months.asMap().forEach((i, month) {
        var days = [];
        listAvailableDates.forEach((item) {
          if (item.year == year &&
              item.month == month &&
              !days.contains(item.day)) {
            if (item.day <= 9) {
              days.add('"0${item.day}"');
            } else {
              days.add('"${item.day}"');
            }
          }
        });

        String mes = month <= 9 ? "0$month" : month;

        if (i == (months.length - 1)) {
          dato += """{"$mes": $days}""";
        } else {
          dato += """{"$mes": $days},""";
        }
      });

      dato += """]}""";

      datos.add(dato);
    });

    pickerDate = datos.toString();

    //****************************************
    _order.method = _method;
    _order.priceTotal = _priceTotal;
    _order.deliveryDate = _deliveryDate;
    _order.deliveryTime = _deliveryTime;
  }

  showDate(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(pickerDate)),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          var select = picker.getSelectedValues();
          setState(() {
            _deliveryDate = "${select[0]}-${select[1]}-${select[2]}";
            _order.deliveryDate = _deliveryDate;
            _order.deliveryTime = _deliveryTime;
            _deliveryDateText = DateFormat.yMMMMd("es_ES").format(
                DateTime.parse("${select[0]}-${select[1]}-${select[2]}"));
          });
        }).showModal(this.context);
  }

  showTime(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(pickerTime), isArray: true),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          var select = picker.getSelectedValues();
          String hora = select[0];
          String minuto = select[1];
          String sigla = select[2];
          int getHora = int.parse(select[0]);
          String getSigla = select[2];
          String mostrarHora = select[0];
          var data = [];

          for (int i = 13; i < 24; i++) {
            data.add(i);
          }

          if (getSigla == "PM") {
            if (getHora < 12) {
              hora = data[(getHora - 1)].toString();
            }
          } else {
            if (getHora >= 12) {
              hora = "01";
              sigla = "AM";
              mostrarHora = "01";
            }
          }

          setState(() {
            _deliveryTime = "${hora}:${minuto}";
            _deliveryTimeText = "${mostrarHora}:${select[1]} ${sigla}";
            _order.deliveryDate = _deliveryDate;
            _order.deliveryTime = _deliveryTime;
          });

          print("Fecha: $_deliveryDate");
          print("Hora: $_deliveryTime");
        }).showModal(this.context);
  }

  void _changeMethod(e) {
    setState(() {
      if (e == 1) {
        _method = 1;
      } else if (e == 2) {
        _method = 2;
      }
    });
    _order.method = _method;
  }

  Future _requestOrder() async {
    setState(() => _loading = true);
    try {
      if (_order.address != null) {
        http.Response response =
            await http.post("${_util.BASE_URL}/orders/create", body: {
          "token": _pref.client_token,
          "method": '${_order.method}',
          "key": _order.key,
          "price_total": '${_order.priceTotal}',
          "cost_shipping": '${_order.costShipping}',
          "delivery_date": _order.deliveryDate,
          "delivery_time": _order.deliveryTime,
          "distance": '${_order.distance}',
          "duration": '${_order.duration}',
          "address": '${_order.address}',
          "items": jsonEncode(_order.items)
        });

        print("=============================================");
        print("ORDER: ${jsonEncode(_order.items)}");
        print("=============================================");
        _rsp = jsonDecode(response.body);

        print("|||||||||||||||||||||||||||||||||||||||||||||");
        print(_rsp);
        print("|||||||||||||||||||||||||||||||||||||||||||||");

        print("ORDER: ${jsonEncode(_order.items)}");
        print(_rsp);
        if (_rsp['ok']) {
          Success success = Success();
          success.price = _rsp['item']['price'];
          success.date_delivery = _rsp['item']['date_delivery'];
          success.address = _rsp['item']['address'];
          _openSuccess(success);
        } else {
          _modal.show(context, "Ups...", "Ocurrio un error.");
        }
      } else {
        _modal.show(context, "COMPLETAR", "Ingrese una dirección.");
      }
      setState(() => _loading = false);
    } catch (e) {
      setState(() => _loading = false);
      _modal.show(context, "Ups...", "No tienes conectividad. $e");
    }
  }

  void _openAddCreditCard() {
    if (_order.address != null) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VAddCreditCard(listCarrito, _order)))
          .then((response) {
        setState(() => listCarrito = response);
        _verify();
      });
    } else {
      _modal.show(context, "COMPLETAR", "Ingrese una dirección.");
    }
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  void _openSuccess(Success success) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VSuccess(
          listCarrito: listCarrito,
          success: success,
        ),
      ),
    ).then((response) {
      setState(() => listCarrito = response);
      _verify();
    });
  }

  addAddress() async {
    if (_pref.client_lat.isNotEmpty && _pref.client_lng.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VAddress(action: "SELECTPOINT"),
        ),
      ).then((point) {
        if (point != null) {
          calculatePrice(point);
        } else {
          print("No seleccionaste");
        }
      });
    } else {
      detectCurrentLocation();
    }
  }

  detectCurrentLocation() async {
    await _pref.init().then((value) {
      setState(() {
        _pref = value;
      });
    });
    await Location().getLocation().then((loc) {
      _pref.client_lat = loc.latitude.toString();
      _pref.client_lng = loc.longitude.toString();
      _pref.commit();
    });
    addAddress();
  }

  Future<Null> calculatePrice(Point point) async {
    setState(() {
      _loading = true;
    });
    try {
      final response = await http.post(
        "${_util.BASE_URL}/map/distancematrix",
        body: {
          "token": _pref.client_token,
          "destinations": "${point.lat}, ${point.lng}",
        },
      );

      var rsp = json.decode(response.body);

      print(rsp);

      if (rsp["ok"]) {
        double priceDelivery = double.parse(rsp["price"].toString());
        setState(() {
          _point.id = point.id;
          _point.lat = point.lat;
          _point.lng = point.lng;
          _point.address = point.address;
          _order.address = point.id;
          _delivery = priceDelivery;
          _order.costShipping = priceDelivery;
          _order.distance = rsp["distance"];
          _order.duration = rsp["duration"];
        });
      }
    } catch (e) {
      print("Error :: $e");
      globalAlerts.alertOne(
        context,
        icon: null,
        title: "Error",
        description: "Ocurrio un error",
      );
    }
    setState(() {
      _loading = false;
    });
  }

  void _verify() {
    if (listCarrito.length <= 0) {
      Navigator.pop(context, listCarrito);
    }
  }

  void launchPhone(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunch(url)) {
      print("Can launch $url");
      await launch(url);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  void initState() {
    super.initState();
    _pref.init().then((value) {
      setState(() {
        _pref = value;
      });
    });
    initializeDateFormatting("es_ES", null).then((_) {});
    loadData();
    _verify();
  }

  @override
  Widget build(BuildContext context) {
    final selectAddress = Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Dirección",
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
                fontSize: 20.0,
//                        fontFamily: 'FrancoisOne',
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10.0),
          Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Color(_util.colorDos), width: 2.0),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  splashColor: Color(_util.colorUno),
                  borderRadius: BorderRadius.circular(8.0),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            child: Text(
                              _point.address != '' && _point.lat != 0
                                  ? _point.address
                                  : "Seleccionar dirección",
                              style: TextStyle(
                                  color: Color(_util.colorTres),
                                  fontSize: 15.0),
                            ),
                          ),
                          Container(
                            child: Icon(
                              _point.address != '' && _point.lat != 0
                                  ? Icons.place
                                  : Icons.keyboard_arrow_down,
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: addAddress,
                ),
              )),
        ],
      ),
    );

    final choosePaymentMethod = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              "Método de pago",
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 10.0),
          Ink(
            color: Colors.white,
            child: InkWell(
              child: Container(
                child: ListTile(
                  leading: Radio(
                    value: 1,
                    groupValue: _method,
                    onChanged: (int e) => _changeMethod(e),
                    activeColor: Color(_util.colorDos),
                  ),
                  title: Text(
                    "Efectivo / Aceptamos (Visa * MasterCard)",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              onTap: () => _changeMethod(1),
            ),
          ),
          Divider(height: 0.0),
         Ink(
            color: Colors.white,
            child: InkWell(
              child: Container(
                child: ListTile(
                  leading: Radio(
                    value: 2,
                    groupValue: _method,
                    onChanged: (int e) => _changeMethod(e),
                    activeColor: Color(_util.colorDos),
                  ),
                  title: Text(
                    "Tarjeta // NO ESTA ACTIVO X EL MOMENTO",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              //onTap: () => _changeMethod(2),
            ),
          ),
      ),
    );

    final selectShippingDate = Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Fecha de envío",
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
                fontSize: 20.0,
//                    fontFamily: 'FrancoisOne',
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: (MediaQuery.of(context).size.width / 2) - 15.0,
                margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4.0,
                    color: !programado ? Color(_util.colorDos) : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Material(
                  color: Color(_util.colorTres),
                  borderRadius: BorderRadius.circular(50.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        "MAÑANA 8:00 AM",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17.0,
                            color: !programado
                                ? Color(_util.colorDos)
                                : Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    onTap: () => setState(() {
                      programado = false;
                      DateTime now = DateTime.now();
                      String year, month, day;

                      year = now.year.toString();
                      month = now.month <= 9 ? "0${now.month}" : "${now.month}";
                      day = now.day <= 9 ? "0${now.day}" : "${now.day}";

                      setState(() {
                        _deliveryDate = "${year}-${month}-${day}";
                        _deliveryTime = DateFormat.Hm().format(now);
                        _deliveryTimeText = DateFormat.jm().format(now);
                        _order.deliveryDate = _deliveryDate;
                        _order.deliveryTime = _deliveryTime;
                        _deliveryDateText = DateFormat.yMMMMd("es_ES")
                            .format(DateTime.parse("${year}-${month}-${day}"));
                      });
                    }),
                  ),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width / 2) - 15.0,
                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4.0,
                    color: programado ? Color(_util.colorDos) : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
               /* child: Material(
                  color: Color(_util.colorTres),
                  borderRadius: BorderRadius.circular(50.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        "Programado",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17.0,
                            color: programado
                                ? Color(_util.colorDos)
                                : Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    onTap: () => setState(() => programado = true),
                  ),
                ),*/
              ),
            ],
          ),
          SizedBox(height: 10.0),
          programado
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: (MediaQuery.of(context).size.width / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Fecha:",
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 15.0, color: Color(_util.texto)),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            width:
                                (MediaQuery.of(context).size.width / 2) - 20.0,
                            height: 40,
                            child: Material(
                              color: Color(0xFFEEEEEE),
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        "$_deliveryDateText",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Icon(Icons.arrow_drop_down),
                                    ),
                                  ],
                                ),
                                onTap: () => showDate(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Hora:",
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 15.0, color: Color(_util.texto)),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            width:
                                (MediaQuery.of(context).size.width / 2) - 20.0,
                            height: 40,
                            child: Material(
                              color: Color(0xFFEEEEEE),
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        "${_deliveryTimeText}",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Icon(Icons.arrow_drop_down),
                                    ),
                                  ],
                                ),
                                onTap: () => showTime(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );

    final paymentInformation = Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    "Costo de productos",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                          child: Text(
                        "${_pref.stg_coin}${_priceTotal.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 15.0),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    "Costo de envío",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                          child: Text(
                        "${_pref.stg_coin}${_delivery.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 15.0),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text("Total a cobrar",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                          child: Text("${_pref.stg_coin}",
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ))),
                      Container(
                          child: Text(
                        (_priceTotal + _delivery).toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final buttonPayment = Positioned(
      bottom: 10.0,
      left: 10.0,
      child: Material(
        color: Color(_util.primaryColor),
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
            width: (MediaQuery.of(context).size.width - 20),
            height: 50.0,
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: !_loading
                        ? Text(_method == 1 ? "Solicitar" : "Continuar",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
//                                            fontFamily: 'FrancoisOne',
                                fontWeight: FontWeight.bold))
                        : SizedBox(
                            child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                                strokeWidth: 5.0),
                            height: 17.0,
                            width: 17.0,
                          ),
                  ),
                ],
              ),
              onTap: !_loading
                  ? _method == 2 ? _openAddCreditCard : _requestOrder
                  : () {},
            )),
      ),
    );

    final contact = Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              "Contactenos si deseas un Pedido Rapido",
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            children: <Widget>[
              Material(
                color: Color(_util.colorDos),
                borderRadius: BorderRadius.circular(50.0),
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Icon(Icons.phone),
                        ),
                        SizedBox(width: 10.0),
                        Container(
                          child: Text("${_pref.stg_phone}"),
                        )
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                  onTap: () => launchPhone(_pref.stg_phone),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, listCarrito);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(_util.primaryColor),
          title: Text("Pago"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, listCarrito);
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                selectAddress,
                selectShippingDate,
                choosePaymentMethod,
                SizedBox(height: 8.0),
                paymentInformation,
                _pref.stg_phone != "" ? contact : SizedBox(),
                SizedBox(height: 70.0),
              ],
            ),
            _method != 0 ? buttonPayment : SizedBox(height: 0.0)
          ],
        ),
      ),
    );
  }
}
