import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:async';
import 'dart:convert';
import '../util/util.dart';
import '../util/pref.dart';
import '../models/globalButtons.dart';
import '../models/globalAlerts.dart';
import '../models/globalTexts.dart';
import '../beans/point.dart';

class VAddress extends StatefulWidget {
  final String action;

  const VAddress({Key key, this.action}) : super(key: key);

  @override
  _VAddressState createState() => _VAddressState();
}

class _VAddressState extends State<VAddress> {
  final refresh = GlobalKey<RefreshIndicatorState>();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalButtons globalButtons = GlobalButtons();
  GlobalAlerts globalAlerts = GlobalAlerts();
  GlobalTexts globalTexts = GlobalTexts();
  Util util = Util();
  Pref pref = Pref();

  List<Point> address = List();
  List<Widget> addressList = List();

  bool loading = false;
  bool loadingRefresh = true;
  bool error = false;

  Future getAddress() async {
    address = [];
    setState(() {
      loadingRefresh = true;
    });
    try {
      print("entra a agregar direccionnnn");
      http.Response response = await http.post("${util.BASE_URL}/client_points",
          body: ({"token": "${pref.client_token}"}));
      var rsp = jsonDecode(response.body);
      if (rsp['ok']) {
        rsp['items'].forEach((item) {
          Point point =
              Point(double.parse(item['lat']), double.parse(item['lng']));
          point.id = int.parse(item['id']);
          point.address = item['address'];
          address.add(point);
        });

        fillAddress();
      }
      setState(() {
        error = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = true;
      });
    }
    setState(() {
      loadingRefresh = false;
    });
  }

  fillAddress() {
    print(address.length);
    addressList = [];
    address.forEach((item) {
      addressList.add(
        ListTile(
          leading: globalTexts.textOne(icon: Icons.place, padding: 0.0),
          title: Row(
            children: <Widget>[
              Expanded(
                child: globalTexts.textOne(
                    title: "${item.address}",
                    textColor: util.colorSix,
                    padding: 0.0,
                    fontFamily: "GeoBook"),
              ),
            ],
          ),
          trailing: globalTexts.textOne(
              icon: Icons.clear,
              padding: 0.0,
              evtX: 10.0,
              evtY: 10.0,
              evt: () => !loading ? deleteAddress(item) : {}),
          onTap: () => selectAddress(item),
        ),
      );
    });
  }

  deleteAddress(Point point) {
    globalAlerts.alertOne(
      context,
      color: 0xFFFFFFFF,
      titleColor: util.colorSix,
      descColor: util.colorSix,
      title: "Espera",
      description: "¿Seguro quieres eliminar esta dirección?",
      optionOne: "Cancelar",
      optionOneColor: util.colorFive,
      optionOneEvt: () {
        Navigator.pop(context);
      },
      optionTwo: "Eliminar",
      optionTwoColor: util.rosado,
      optionTwoEvt: () async {
        Navigator.of(context).pop();
        try {
          setState(() {
            loading = true;
          });

          final response = await http.post(
              "${util.BASE_URL}/client_points/remove",
              body: {"token": pref.client_token, "id": point.id.toString()});

          var rsp = jsonDecode(response.body);
          print(rsp);
          if (rsp['ok']) {
            setState(() {
              address.removeAt(address.indexOf(point));
            });
            globalAlerts.snackBar(scaffoldKey, "Eliminado correctamente", 1);
            fillAddress();
          } else {
            globalAlerts.alertOne(context,
                description: "Ocurrio un error al eliminar.");
          }

          setState(() {
            loading = false;
          });
        } catch (e) {
          setState(() {
            loading = false;
          });
          globalAlerts.alertOne(context);
        }
      },
    );
  }

  selectAddress(Point point) {
    if (widget.action == "SELECTPOINT") {
      Navigator.pop(context, point);
    }
  }

  addAddress() async {
    if (pref.client_lat.isNotEmpty && pref.client_lng.isNotEmpty) {
      Navigator.pushNamed(context, "/addPoint").then((_) => loadData());
    } else {
      detectCurrentLocation();
    }
  }

  detectCurrentLocation() async {
    await pref.init().then((value) {
      setState(() {
        pref = value;
      });
    });
    await Location().getLocation().then((loc) {
      pref.client_lat = loc.latitude.toString();
      pref.client_lng = loc.longitude.toString();
      pref.commit();
    });
    addAddress();
  }

  Future<Null> loadData() {
    return getAddress().then((rsp) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    pref.init().then((value) {
      setState(() {
        pref = value;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refresh.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewAddress = Column(children: addressList);
    final viewLoading = globalAlerts.loading(context);
    final viewError = globalAlerts.error(context, () => loadData);
    final viewEmpty = globalAlerts.error(
        context,
        () => () =>
            Navigator.pushNamed(context, "/addPoint").then((_) => loadData()),
        img: "",
        icon: globalTexts.textOne(
            icon: Icons.chrome_reader_mode, padding: 0.0, iconSize: 60.0),
        title: "Todavía no tienes direcciones guardadas",
        textButton: "Agregar dirección");

    final ViewAddAddress = Positioned(
      bottom: 0.0,
      child: globalButtons.buttonTwo(
        context,
        minWidth: double.minPositive,
        colorButton: util.primaryColor,
        title: "Agregar dirección",
        evt: addAddress,
      ),
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(util.primaryColor),
          title: Text("Direcciones"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: RefreshIndicator(
            key: refresh,
            onRefresh: loadData,
            child: Stack(
              children: <Widget>[
                ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[viewAddress, SizedBox(height: 60.0)],
                ),
                !loadingRefresh ? ViewAddAddress : SizedBox(),
                loading ? viewLoading : SizedBox(),
                addressList.length == 0 && !loading && !loadingRefresh && !error
                    ? viewEmpty
                    : SizedBox(),
                error ? viewError : SizedBox(),
              ],
            )),
      ),
    );
  }
}
