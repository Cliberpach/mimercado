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

class VRegister extends StatefulWidget {
  @override
  _VRegisterState createState() => _VRegisterState();
}

class _VRegisterState extends State<VRegister> {
  Util util = Util();
  Pref pref = Pref();
  Modal modal = Modal();
  GloblaTextField globalTextFild = GloblaTextField();
  GlobalButtons globalButtons = GlobalButtons();
  GlobalAlerts globalAlerts = GlobalAlerts();

  String name = "";
  String surname = "";
  String dni = "";
  String email = "";
  String password = "";
  String phone = "";
  bool terms = false;

  final formKey = GlobalKey<FormState>();
  var tcName = TextEditingController();
  var tcSurname = TextEditingController();
  var tcDni = TextEditingController();
  var tcEmail = TextEditingController();
  var tcPassword = TextEditingController();
  var tcPhone = TextEditingController();

  FocusNode fnName = FocusNode();
  FocusNode fnSurname = FocusNode();
  FocusNode fnDni = FocusNode();
  FocusNode fnEmail = FocusNode();
  FocusNode fnPassword = FocusNode();
  FocusNode fnPhone = FocusNode();

  bool loading = false;

  Future<Null> saveDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });

      try {
        if (terms) {
          formKey.currentState.save();

          final response =
              await http.post("${util.BASE_URL}/auth/register", body: {
            "name": name,
            "surname": surname,
            "dni": dni,
            "email": email,
            "password": password,
            "phone": phone,
          });

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
        } else {
          globalAlerts.alertOne(
            context,
            icon: null,
            title: "Importante",
            description:
                "Tienes que leer y aceptar los términos y condiciones.",
          );
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        globalTextFild.textOne(
          context,
          validator: (input) => input.length <= 2 ? 'Nombre inválido' : null,
          controller: tcName,
          onSaved: (input) => setState(() => name = input),
          focusNode: fnName,
          focusNodeNext: fnSurname,
          hintText: 'Nombre',
          labelText: 'Nombre',
          focusedBorderColor: util.greenAccent,
        ),
        globalTextFild.textOne(
          context,
          validator: (input) => input.length <= 4 ? 'Apellido inválido' : null,
          controller: tcSurname,
          onSaved: (input) => setState(() => surname = input),
          focusNode: fnSurname,
          focusNodeNext: fnDni,
          hintText: 'Apellido',
          labelText: 'Apellido',
          focusedBorderColor: util.greenAccent,
        ),
        globalTextFild.textOne(context,
            keyboardType: TextInputType.number,
            validator: (input) => input.length <= 7 ? 'DNI inválido' : null,
            controller: tcDni,
            onSaved: (input) => setState(() => dni = input),
            focusNode: fnDni,
            focusNodeNext: fnEmail,
            hintText: 'DNI',
            labelText: 'DNI',
            focusedBorderColor: util.greenAccent,
            max: 8),
        globalTextFild.textTwo(context, Icons.email,
            validator: (input) => (!input.contains('@') || !input.contains('.'))
                ? 'Email incorrecto'
                : null,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            controller: tcEmail,
            onSaved: (input) => setState(() => email = input),
            focusNode: fnEmail,
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
            focusNodeNext: fnPhone,
            textInputAction: TextInputAction.next,
            hintText: 'Contraseña',
            labelText: 'Contraseña',
            focusedBorderColor: util.greenAccent),
        globalTextFild.textTwo(context, Icons.phone,
            keyboardType: TextInputType.number,
            validator: (input) =>
                input.length <= 8 ? 'Teléfono inválido' : null,
            controller: tcPhone,
            onSaved: (input) => setState(() => phone = input),
            focusNode: fnPhone,
            textInputAction: TextInputAction.done,
            hintText: 'Teléfono',
            labelText: 'Teléfono',
            focusedBorderColor: util.greenAccent,
            max: 9),
      ]),
    );

    final registerButton = globalButtons.buttonOne(
      evt: saveDate,
      loading: loading,
      title: "Registrarme",
      colorButton: util.primaryColor,
    );

    final widgetTerms = Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Switch(
                value: terms,
                activeColor: Color(0xFF00CED3),
                onChanged: (e) => setState(() => terms = e),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 140.0),
                child: InkWell(
                  onTap: () => modal.navigator(util.TERMS_URL),
                  child: Text(
                    "Acepto los Términos y condiciones.",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.indigo,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(util.primaryColor),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Registrarme"),
        ),
        body: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              formulario,
              widgetTerms,
              registerButton,
            ],
          ),
        ),
      ),
    );
  }
}
