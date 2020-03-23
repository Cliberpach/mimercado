import 'package:anvic/beans/success.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/pay/input_formatters.dart';
import '../widgets/pay/payment_card.dart';
import '../widgets/pay/my_strings.dart';
import '../widgets/modal.dart';
import '../beans/carrito.dart';
import '../beans/order.dart';
import '../util/pref.dart';
import '../util/util.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'VSuccess.dart';

class VAddCreditCard extends StatefulWidget {
  List<Carrito> listCarrito;
  Order _order;

  VAddCreditCard(this.listCarrito, this._order);

  // ******************************************
  @override
  _VAddCreditCardState createState() =>
      new _VAddCreditCardState(listCarrito, _order);
}

class _VAddCreditCardState extends State<VAddCreditCard> {
  List<Carrito> listCarrito;
  Order _order;

  _VAddCreditCardState(this.listCarrito, this._order);

  // ******************************************
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidate = false;

  Util _util = Util();
  Pref _pref = Pref();
  Modal _modal = Modal();
  Map _rsp;
  bool _loading = false;
  String _message = "";

  FocusNode _fnName = FocusNode();
  FocusNode _fnNumber = FocusNode();
  FocusNode _fnCvv = FocusNode();
  FocusNode _fnDate = FocusNode();

  void _verify() {
    if (listCarrito.length <= 0) {
      Navigator.pop(context, listCarrito);
    }
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

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    super.initState();
    _pref.init().then((value) {
      setState(() {
        _pref = value;
      });
    });
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
    _verify();
  }

  @override
  Widget build(BuildContext context) {
    Widget title(text) {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.0,
            color: Color(_util.blackPrimary),
          ),
        ),
      );
    }

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
                        "S/.${_order.priceTotal.toStringAsFixed(2)}",
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
                        "S/.${_order.costShipping.toStringAsFixed(2)}",
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
//                        fontFamily: 'FrancoisOne',
                      )),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                          child: Text("S/.",
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
//                                fontFamily: 'FrancoisOne',
                              ))),
                      Container(
                          child: Text(
                        (_order.priceTotal + _order.costShipping)
                            .toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
//                              fontFamily: 'FrancoisOne',
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

    final creditCard = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 20.0),
            title("Titular (nombre en la tarjeta)"),
            Container(
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (String value) =>
                    value.isEmpty ? Strings.fieldReq : null,
                onSaved: (String value) {
                  _paymentCard.name = value;
                },
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                focusNode: _fnName,
                onFieldSubmitted: (term) {
                  FocusScope.of(context).requestFocus(_fnNumber);
                },
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color(_util.brownPrimary),
                ),
                decoration: InputDecoration(
                  hintText: 'Nombre completo',
                  filled: true,
                  prefixIcon:
                      Icon(Icons.person, color: Color(_util.brownPrimary)),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(_util.greenAccent), width: 1.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(25.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(_util.greenAccent), width: 2.0),
                      borderRadius: BorderRadius.circular(25.0)),
                ),
              ),
            ),
            new SizedBox(height: 10.0),
            title("Número de tarjeta"),
            Container(
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: CardUtils.validateCardNum,
                controller: numberController,
                onSaved: (String value) {
//                      print('onSaved = $value');
//                      print('Num controller has = ${numberController.text}');
                  _paymentCard.number = CardUtils.getCleanedNumber(value);
                },
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  new LengthLimitingTextInputFormatter(19),
                  new CardNumberInputFormatter()
                ],
                textInputAction: TextInputAction.next,
                focusNode: _fnNumber,
                onFieldSubmitted: (term) {
                  FocusScope.of(context).requestFocus(_fnCvv);
                },
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color(_util.brownPrimary),
                ),
                decoration: InputDecoration(
                  hintText: 'XXXX XXXX XXXX XXXX',
                  filled: true,
                  prefixIcon: CardUtils.getCardIcon(_paymentCard.type),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(_util.greenAccent), width: 1.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(25.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(_util.greenAccent), width: 2.0),
                      borderRadius: BorderRadius.circular(25.0)),
                ),
              ),
            ),
            new SizedBox(height: 10.0),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: ((MediaQuery.of(context).size.width / 2) - 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title("Código de seguridad"),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: CardUtils.validateCVV,
                            onSaved: (value) {
                              _paymentCard.cvv = int.parse(value);
                            },
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              new LengthLimitingTextInputFormatter(4),
                            ],
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Color(_util.brownPrimary),
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: _fnCvv,
                            onFieldSubmitted: (term) {
                              FocusScope.of(context).requestFocus(_fnDate);
                            },
                            decoration: InputDecoration(
                              hintText: 'CVV',
                              filled: true,
                              prefixIcon: Container(
                                  padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
                                  child: Image.asset(
                                    'assets/img/pay/card_cvv.png',
                                    width: 15.0,
                                  )),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(_util.greenAccent),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(25.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(_util.greenAccent),
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(25.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: ((MediaQuery.of(context).size.width / 2) - 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title("Fecha de expiración"),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: CardUtils.validateDate,
                            onSaved: (value) {
                              List<int> expiryDate =
                                  CardUtils.getExpiryDate(value);
                              _paymentCard.month = expiryDate[0];
                              _paymentCard.year = expiryDate[1];
                            },
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              new LengthLimitingTextInputFormatter(4),
                              new CardMonthInputFormatter()
                            ],
                            textInputAction: TextInputAction.done,
                            focusNode: _fnDate,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Color(_util.brownPrimary),
                            ),
                            decoration: InputDecoration(
                              hintText: 'MM/YY',
                              filled: true,
                              prefixIcon: Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Image.asset(
                                    'assets/img/pay/calender.png',
                                    width: 15.0,
                                  )),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(_util.greenAccent),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(25.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(_util.greenAccent),
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(25.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            paymentInformation,
            SizedBox(height: 20.0),
            Container(
              child: ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0)),
                child: RaisedButton(
                  color: Color(_util.primaryColor),
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Text(
                    "Pagar",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontFamily: 'Geomanist',
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: !_loading ? _validateInputs : () {},
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            )
          ],
        ),
      ),
    );

    final loadingView = Container(
      width: MediaQuery.of(context).size.width - 0.0,
      height: MediaQuery.of(context).size.height - 50.0,
      color: Color(0x91000000),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 5.0),
              height: 40.0,
              width: 40.0,
            ),
            SizedBox(height: 15.0),
            Container(
              child: Text(
                "$_message",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: Text(
                "Por favor no cierre esta pantalla",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () {
        !_loading ? Navigator.pop(context, listCarrito) : null;
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
              !_loading ? Navigator.pop(context, listCarrito) : null;
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            creditCard,
            _loading ? loadingView : SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void _validateInputs() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() => _autoValidate = true);
      _showInSnackBar('Datos incorrectos.');
    } else {
      try {
        setState(() {
          _loading = true;
          _message = "Validando datos de la tarjeta";
        });
        form.save();
        final urlSend = 'https://secure.culqi.com/v2/tokens';

        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_pref.stg_culqi_pk_public}',
        };
        final body = """{
          "card_number":"${_paymentCard.number}",
          "cvv":"${_paymentCard.cvv}",
          "expiration_month":"${_paymentCard.month}",
          "expiration_year":"20${_paymentCard.year}",
          "email":"${_pref.client_email}"
        }""";
        final response = await http.post(urlSend, body: body, headers: headers);
        var rsp = json.decode(response.body);
        if (rsp["object"] == "error") {
          _modal.show(context, "Ups...", rsp["user_message"]);
          setState(() {
            _loading = false;
            _message = "";
          });
        } else if (rsp["object"] == "token") {
          createCharge(rsp["id"]);
          setState(() {
            _message = "Procesando pago";
          });
        }
      } catch (e) {
        _modal.show(context, "Ups...", "Ocurrio un error.");
        setState(() {
          _loading = false;
          _message = "";
        });
      }
    }
  }

  void createCharge(key) async {
    try {
      final response = await http.post("${_util.BASE_URL}/culqui", body: {
        "token": "${_pref.client_token}",
        "amount":
            "${((_order.priceTotal + _order.costShipping) * 100).round()}",
        "email": "${_pref.client_email}",
        "key": "$key"
      });

      var rsp = json.decode(response.body);

      if (rsp["object"] == "error") {
        _modal.show(context, "Ups...", rsp["user_message"]);
        setState(() {
          _loading = false;
          _message = "";
        });
      } else if (rsp["object"] == "charge") {
        _order.key = rsp["id"];
        saveData();
      }
    } catch (e) {
      _modal.show(context, "Ups...", "Ocurrio un error. $e");
      setState(() {
        _loading = false;
        _message = "";
      });
    }
  }

  void saveData() async {
    try {
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

      var rsp = json.decode(response.body);
      if (rsp['ok']) {
        Success success = Success();
        success.price = _rsp['item']['price'];
        success.date_delivery = _rsp['item']['date_delivery'];
        success.address = _rsp['item']['address'];
        _openSuccess(success);
      } else {
        _modal.show(
            context, "Ups...", "Ocurrio un error, contacta con soporte.");
        setState(() {
          _loading = false;
          _message = "";
        });
      }
    } catch (e) {
      _modal.show(context, "Ups...", "Ocurrio un error. $e");
      setState(() {
        _loading = false;
        _message = "";
      });
    }
  }
}
