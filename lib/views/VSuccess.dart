import 'package:anvic/beans/success.dart';
import 'package:anvic/util/Config.dart';
import 'package:anvic/widgets/global_text.dart';
import 'package:flutter/material.dart';
import '../util/pref.dart';
import '../util/util.dart';
import '../beans/carrito.dart';

class VSuccess extends StatefulWidget {
  List<Carrito> listCarrito;
  Success success;

  VSuccess({Key key, @override this.listCarrito, @override this.success});

  @override
  _VSuccessState createState() => _VSuccessState();
}

class _VSuccessState extends State<VSuccess> {
  Util util = Util();
  Pref pref = Pref();

  @override
  void initState() {
    super.initState();
    pref.init().then((value) {
      setState(() {
        pref = value;
      });
    });
    setState(() => widget.listCarrito = []);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, widget.listCarrito);
      },
      child: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GlobalText(
                    icon: Icon(
                      Icons.check_circle,
                      color: Color(util.greenPrimary),
                      size: 100.0,
                    ),
                  ),
                  GlobalText(
                    textTitle: "¡FELICIDADES!",
                    textFontSize: 20,
                    textFontWeight: FontWeight.w500,
                  ),
                  GlobalText(
                    textTitle: "Tu pedido ha sido realizado con éxito.",
                    textColor: Config.colorTextAccent,
                  ),
                  ListTile(
                    leading: GlobalText(
                      icon: Icon(Icons.monetization_on),
                    ),
                    title: GlobalText(
                      margin: 0,
                      textTitle: "Monto",
                      textFontWeight: FontWeight.w500,
                    ),
                    subtitle: GlobalText(
                      margin: 0,
                      textTitle:
                          "${pref.stg_coin}${widget.success.price.toStringAsFixed(2)}",
                      textFontSize: 25,
                      textFontWeight: FontWeight.w500,
                    ),
                  ),
                  ListTile(
                    leading: GlobalText(
                      icon: Icon(Icons.access_time),
                    ),
                    title: GlobalText(
                      margin: 0,
                      textTitle: "Fecha de entrega aproximada",
                      textFontWeight: FontWeight.w500,
                    ),
                    subtitle: GlobalText(
                      margin: 0,
                      textTitle: widget.success.date_delivery,
                    ),
                  ),
                  ListTile(
                    leading: GlobalText(
                      icon: Icon(Icons.place),
                    ),
                    title: GlobalText(
                      margin: 0,
                      textTitle: "Dirección",
                      textFontWeight: FontWeight.w500,
                    ),
                    subtitle: GlobalText(
                      margin: 0,
                      textTitle: widget.success.address,
                    ),
                  ),
                  GlobalText(
                    background: Color(util.greenPrimary),
                    textTitle: "Continuar",
                    textColor: Colors.white,
                    padding: 10,
                    radius: 5,
                    callback: () {
                      Navigator.pop(context, widget.listCarrito);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
