import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../util/util.dart';
import '../util/pref.dart';
import '../models/globalAlerts.dart';
import 'package:location/location.dart';

class VSplash extends StatefulWidget {
  @override
  _VSplashState createState() => _VSplashState();
}

class _VSplashState extends State<VSplash> {
  final refresh = GlobalKey<RefreshIndicatorState>();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalAlerts globalAlerts = GlobalAlerts();
  Util util = Util();
  Pref pref = Pref();

  bool loading = false;
  bool error = false;

  setup() async {
    await pref.init().then((value) {
      setState(() {
        pref = value;
      });
    });

    Location().getLocation().then((loc) {
      pref.client_lat = loc.latitude.toString();
      pref.client_lng = loc.longitude.toString();
      pref.commit();
    });

    if (pref.client_token == "") {
      print("Entro aqui: token == vacio ->VLogin");
      util.clearPref();
      Navigator.pushNamed(context, "/login");
    } else {
      print("Entro aqui: Logeado == exist ->getSplash");
      getSplash();
    }
  }

  Future<Null> getSplash() async {
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post("${util.BASE_URL}/home/splash",
          body: ({"token": "${pref.client_token}"}));
      var rsp = jsonDecode(response.body);

      if (rsp['ok']) {
        print("Entro aqui: rsp == true -> VHome");
        var rspClient = rsp["client"];
        var rspStg = rsp["stg"];
        util.savePreferences(rspClient, rspStg);
        Navigator.pushNamed(context, "/home");
        setState(() {
          error = false;
        });
      } else {
        print("Entro aqui: rsp == false -> VLogin");
        util.clearPref();
        Navigator.pushNamed(context, "/login");
      }
    } catch (e) {
      print(e);
      setState(() {
        error = true;
      });
    }
    setState(() {
      loading = false;
    });
  }

  Future<Null> loadData() {
    return getSplash().then((rsp) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    final viewLoading = globalAlerts.loading(context);
    final viewError = globalAlerts.error(context, () => loadData);

    return Scaffold(
      backgroundColor: Color(util.primaryColor),
      body: RefreshIndicator(
          key: refresh,
          onRefresh: loadData,
          child: Stack(
            children: <Widget>[
              error ? viewError : SizedBox(),
              loading ? viewLoading : SizedBox(),
            ],
          )),
    );
  }
}
