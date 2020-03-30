import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../../util/util.dart';
import '../../util/pref.dart';
import '../../models/globalTextField.dart';
import '../../models/globalButtons.dart';
import '../../models/globalAlerts.dart';
import '../../widgets/modal.dart';

class VLogin extends StatefulWidget {
  @override
  _VLoginState createState() => _VLoginState();
}

class _VLoginState extends State<VLogin> {
  Util util = Util();
  Pref pref = Pref();
  Modal modal = Modal();
  GloblaTextField globalTextFild = GloblaTextField();
  GlobalButtons globalButtons = GlobalButtons();
  GlobalAlerts globalAlerts = GlobalAlerts();

  String username = "";
  String password = "";

  final formKey = GlobalKey<FormState>();
  var tcUsername = TextEditingController();
  var tcPassword = TextEditingController();

  FocusNode fnUsername = FocusNode();
  FocusNode fnPassword = FocusNode();

  bool loading = false;

  closeKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<Null> saveDate() async {
    closeKeyboard();
    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });

      try {
        formKey.currentState.save();

        final response = await http.post("${util.BASE_URL}/auth/login",
            body: {"username": username, "password": password});

        var rsp = json.decode(response.body);

        if (rsp["ok"]) {
          var rspClient = rsp["client"];
          var rspStg = rsp["stg"];
          pref.client_name = rspClient["name"];
          pref.client_surname = rspClient["surname"];
          pref.client_dni = rspClient["dni"];
          pref.client_email = rspClient["email"];
          pref.client_phone = rspClient["phone"];
          pref.client_token = rspClient["token"];
          pref.stg_url_api = rspStg["url_api"];
          pref.stg_url_web = rspStg["url_web"];
          pref.stg_address = rspStg["address"];
          pref.stg_brand = rspStg["brand"];
          pref.stg_coin = rspStg["coin"];
          pref.stg_coin_name = rspStg["coin_name"];
          pref.stg_coin_short = rspStg["coin_short"];
          pref.stg_cost_shipping = rspStg["cost_shipping"];
          pref.stg_cost_shipping_km = rspStg["cost_shipping_km"];
          pref.stg_min_shipping_km = rspStg["min_shipping_km"];
          pref.stg_culqi_pk_private = rspStg["culqi_pk_private"];
          pref.stg_culqi_pk_public = rspStg["culqi_pk_public"];
          pref.stg_description = rspStg["description"];
          pref.stg_email = rspStg["email"];
          pref.stg_key_firebase = rspStg["key_firebase"];
          pref.stg_key_maps = rspStg["key_maps"];
          pref.stg_lat = rspStg["lat"];
          pref.stg_lng = rspStg["lng"];
          pref.stg_name = rspStg["name"];
          pref.stg_phone = rspStg["phone"];
          pref.stg_time_open = rspStg["time_open"];
          pref.stg_time_close = rspStg["time_close"];
          await pref.commit();

          Navigator.pushNamed(context, "/home");
        } else {
          globalAlerts.alertOne(context,
              icon: null, title: "Ocurrio un error", description: rsp['msg']);
        }
      } catch (e) {
        globalAlerts.alertOne(context, icon: null);
      }

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formulario = Form(
      key: formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            globalTextFild.textTwo(context, Icons.email,
                validator: (input) =>
                    (!input.contains('@') || !input.contains('.'))
                        ? 'Email incorrecto'
                        : null,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                controller: tcUsername,
                onSaved: (input) => setState(() => username = input),
                focusNode: fnUsername,
                focusNodeNext: fnPassword,
                hintText: 'Email',
                labelText: 'Email',
                focusedBorderColor: util.greenAccent),
            globalTextFild.textTwo(context, Icons.lock,
                validator: (input) =>
                    input.length <= 2 ? 'Contraseña incorrecta' : null,
                textCapitalization: TextCapitalization.none,
                obscureText: true,
                controller: tcPassword,
                onSaved: (input) => setState(() => password = input),
                focusNode: fnPassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: saveDate,
                hintText: 'Contraseña',
                labelText: 'Contraseña de App',
                focusedBorderColor: util.greenAccent),
          ]),
    );

    /*final recoverPassword = Center(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "¿Has olvidado tu contraseña?",
            style: TextStyle(
              fontSize: 18.0,
              color: Color(util.leadAccent),
            ),
          ),
        ),
        onTap: () => Navigator.pushNamed(context, "/recover"),
      ),
    );*/

    final loginButton = globalButtons.buttonOne(
      evt: saveDate,
      loading: loading,
      title: "Iniciar sesión",
      colorButton: util.primaryColor,
    );

    final registerButton = Center(
      child: globalButtons.buttonOne(
        minWidth: double.minPositive,
        title: "Registrarme",
        borderRadius: 10.0,
        colorButton: util.greenAccent,
        paddingY: 10.0,
        evt: () => Navigator.pushNamed(context, "/register"),
      ),
    );

    final logoAnvic = Container(
      height: 320,

      decoration: BoxDecoration(

          image: DecorationImage(
        image: AssetImage("assets/img/logo_png.png"),
      )),
    );

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            closeKeyboard();
          },
          child: Center(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                logoAnvic,
                formulario,
                loginButton,
                //recoverPassword,
                registerButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
