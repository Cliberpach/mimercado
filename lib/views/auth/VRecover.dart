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

class VRecover extends StatefulWidget {
  @override
  _VRecoverState createState() => _VRecoverState();
}

class _VRecoverState extends State<VRecover> {
  Util util = Util();
  Pref pref = Pref();
  Modal modal = Modal();
  GloblaTextField globalTextFild = GloblaTextField();
  GlobalButtons globalButtons = GlobalButtons();
  GlobalAlerts globalAlerts = GlobalAlerts();

  String email = "";

  final formKey = GlobalKey<FormState>();
  var tcEmail = TextEditingController();

  FocusNode fnEmail = FocusNode();

  bool loading = false;

  Future<Null> saveDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });

      try {
        formKey.currentState.save();

        final response = await http
            .post("${util.BASE_URL}/auth/recover", body: {"email": email});

        var rsp = json.decode(response.body);

        if (rsp["ok"]) {
          modal.show(context, "¡Bien!", rsp['msg']);
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
                controller: tcEmail,
                onSaved: (input) => setState(() => email = input),
                focusNode: fnEmail,
                hintText: 'Email',
                labelText: 'Email',
                focusedBorderColor: util.greenAccent),
          ]),
    );

    final recoverButton = globalButtons.buttonOne(
      evt: saveDate,
      loading: loading,
      title: "Recuperar contraseña",
      colorButton: util.primaryColor,
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
          title: Text("Recuperar contraseña"),
        ),
        body: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              formulario,
              recoverButton,
            ],
          ),
        ),
      ),
    );
  }
}
