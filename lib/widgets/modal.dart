import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Modal{
    // MOSTRAR MENSAJE EN MODAL
    void show(context,title,description) {
        showDialog(
        context: context,
        builder: (BuildContext context) {
            return AlertDialog(
                title: new Text(title),
                content: new Text(description),
                actions: <Widget>[
                    FlatButton(
                    child: new Text("Cerrar"),
                    onPressed: () {Navigator.of(context).pop();},
                    ),
                ],
            );
        },
        );
    }

    // MOSTRAR MENSAJE EN MODAL
    void confirm(context,title,description,action) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {Navigator.of(context).pop();},
              ),
              FlatButton(
                child: Text("Aceptar"),
                onPressed: () {
                  action();
                  // Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    // ABRIR NAVEGADOR
    void navigator(navigate) async {
        final url = navigate;
        if (await canLaunch(url)) {
            await launch(url);
        } else {
            throw 'Could not launch $url';
        }
    }
 
    // TOAST
    void toast(message){
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
    }

}