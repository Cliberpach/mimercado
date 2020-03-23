import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../../util/util.dart';
import '../../util/pref.dart';
import '../../models/globalTextField.dart';
import '../../models/globalButtons.dart';
import '../../widgets/modal.dart';

class VProfilePassword extends StatefulWidget {
  @override
  _VProfilePasswordState createState() => _VProfilePasswordState();
}

class _VProfilePasswordState extends State<VProfilePassword> {
  Util util = Util();
  Pref pref = Pref();
  Modal modal = Modal();
  GloblaTextField globalTextFild = GloblaTextField();
  GlobalButtons globalButtons = GlobalButtons();

  String current_password = "";
  String new_password = "";
  String new_password2 = "";

  final formKey = GlobalKey<FormState>();
  var tcCurrent_password = TextEditingController();
  var tcSurname = TextEditingController();
  var tcNew_password = TextEditingController();
  var tcNew_password2 = TextEditingController();

  FocusNode fnCurrent_password = FocusNode();
  FocusNode fnNew_password = FocusNode();
  FocusNode fnNew_password2 = FocusNode();

  bool loading = false;

  clear() {
    tcCurrent_password.clear();
    tcNew_password.clear();
    tcNew_password2.clear();
  }

  Future<Null> saveDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });

      try {
        formKey.currentState.save();

        final response =
            await http.post("${util.BASE_URL}/profile/changePassword", body: {
          "token": pref.client_token,
          "current_password": current_password,
          "new_password": new_password,
          "new_password2": new_password2
        });

        var rsp = json.decode(response.body);

        if (rsp["ok"]) {
          clear();
          modal.toast("Contraseña actualizada");
        } else {
          modal.show(context, "Ocurrio un error", rsp['msg']);
        }
      } catch (e) {
        modal.show(context, "Ocurrio un error", "No tienes conectividad.");
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
            globalTextFild.textOne(
              context,
              validator: (input) =>
                  input.length <= 2 ? 'Contraseña incorrecta' : null,
              textCapitalization: TextCapitalization.none,
              obscureText: true,
              controller: tcCurrent_password,
              onSaved: (input) => setState(() => current_password = input),
              focusNode: fnCurrent_password,
              focusNodeNext: fnNew_password,
              hintText: 'Contraseña actual',
              labelText: 'Contraseña actual',
            ),
            globalTextFild.textOne(
              context,
              validator: (input) =>
                  input.length <= 2 ? 'Contraseña inválida' : null,
              textCapitalization: TextCapitalization.none,
              obscureText: true,
              controller: tcNew_password,
              onSaved: (input) => setState(() => new_password = input),
              focusNode: fnNew_password,
              focusNodeNext: fnNew_password2,
              hintText: 'Nueva Contraseña',
              labelText: 'Nueva Contraseña',
            ),
            globalTextFild.textOne(
              context,
              validator: (input) =>
                  input.length <= 2 ? 'Contraseña inválida' : null,
              textCapitalization: TextCapitalization.none,
              obscureText: true,
              controller: tcNew_password2,
              onSaved: (input) => setState(() => new_password2 = input),
              focusNode: fnNew_password2,
              textInputAction: TextInputAction.done,
              hintText: 'Repite la nueva contraseña',
              labelText: 'Nueva contraseña',
            ),
          ]),
    );

    return Center(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          formulario,
          globalButtons.buttonOne(
            evt: saveDate,
            loading: loading,
            title: "Cambiar contraseña",
            colorButton: util.primaryColor,
          ),
        ],
      ),
    );
  }
}
