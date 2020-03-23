import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../../util/util.dart';
import '../../util/pref.dart';
import '../../models/globalTextField.dart';
import '../../models/globalButtons.dart';
import '../../widgets/modal.dart';

class VProfileInformation extends StatefulWidget {
  @override
  _VProfileInformationState createState() => _VProfileInformationState();
}

class _VProfileInformationState extends State<VProfileInformation> {
  Util util = Util();
  Pref pref = Pref();
  Modal modal = Modal();
  GloblaTextField globalTextFild = GloblaTextField();
  GlobalButtons globalButtons = GlobalButtons();

  String name = "";
  String surname = "";
  String dni = "";
  String phone = "";

  final formKey = GlobalKey<FormState>();
  var tcName = TextEditingController();
  var tcSurname = TextEditingController();
  var tcDni = TextEditingController();
  var tcPhone = TextEditingController();

  FocusNode fnName = FocusNode();
  FocusNode fnSurname = FocusNode();
  FocusNode fnDni = FocusNode();
  FocusNode fnPhone = FocusNode();

  bool loading = false;

  init() {
    setState(() {
      tcName.text = pref.client_name;
      tcSurname.text = pref.client_surname;
      tcDni.text = pref.client_dni;
      tcPhone.text = pref.client_phone;
    });
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
            await http.post("${util.BASE_URL}/profile/update", body: {
          "token": pref.client_token,
          "name": name,
          "surname": surname,
          "dni": dni,
          "phone": phone
        });

        var rsp = json.decode(response.body);

        if (rsp["ok"]) {
          pref.client_name = name;
          pref.client_surname = surname;
          pref.client_dni = dni;
          pref.client_phone = phone;
          pref.commit();
          modal.toast("Información actualizada");
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
    init();
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
                  input.length <= 2 ? 'Nombre inválido' : null,
              controller: tcName,
              onSaved: (input) => setState(() => name = input),
              focusNode: fnName,
              focusNodeNext: fnSurname,
              hintText: 'Nombre',
              labelText: 'Nombre',
            ),
            globalTextFild.textOne(
              context,
              validator: (input) =>
                  input.length <= 4 ? 'Apellido inválido' : null,
              controller: tcSurname,
              onSaved: (input) => setState(() => surname = input),
              focusNode: fnSurname,
              focusNodeNext: fnDni,
              hintText: 'Apellido',
              labelText: 'Apellido',
            ),
            globalTextFild.textOne(context,
                keyboardType: TextInputType.number,
                validator: (input) => input.length <= 7 ? 'DNI inválido' : null,
                controller: tcDni,
                onSaved: (input) => setState(() => dni = input),
                focusNode: fnDni,
                focusNodeNext: fnPhone,
                hintText: 'DNI',
                labelText: 'DNI',
                max: 8),
            globalTextFild.textOne(context,
                keyboardType: TextInputType.number,
                validator: (input) =>
                    input.length <= 8 ? 'Teléfono inválido' : null,
                controller: tcPhone,
                onSaved: (input) => setState(() => phone = input),
                focusNode: fnPhone,
                textInputAction: TextInputAction.done,
                hintText: 'Teléfono',
                labelText: 'Teléfono',
                max: 9),
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
            title: "Guardar cambios",
            colorButton: util.primaryColor,
          ),
        ],
      ),
    );
  }
}
