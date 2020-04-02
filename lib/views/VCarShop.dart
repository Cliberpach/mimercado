import 'package:anvic/util/Config.dart';
import 'package:anvic/widgets/global_text.dart';
import 'package:flutter/material.dart';
import '../util/pref.dart';
import '../util/util.dart';
import '../widgets/modal.dart';
import '../widgets/widget_car.dart';
import '../beans/package.dart';
import '../beans/product.dart';
import '../beans/carrito.dart';
import '../models/product_car_shop.dart';
import '../models/package_car_shop.dart';
import '../models/titles_home.dart';
import 'VProduct.dart';
import 'VPackage.dart';
import 'VPayment.dart';

class VCarShop extends StatefulWidget {
  List<Carrito> listCarrito;

  VCarShop(this.listCarrito);

  // ******************************************
  @override
  _VCarShopState createState() => _VCarShopState(listCarrito);
}

class _VCarShopState extends State<VCarShop> {
  List<Carrito> listCarrito;

  _VCarShopState(this.listCarrito);

  // ******************************************

  Util _util = Util();
  Pref _pref = Pref();
  Modal _modal = Modal();
  Titles _title = Titles();
  List<Widget> listProducts = List();
  List<Widget> listPackages = List();

  double _priceTotal = 0.0;
  double _delivery = 0.0;

  void _verify() {
    if (listCarrito.length <= 0) {
      Navigator.pop(context, listCarrito);
    }

    setState(() {
      _priceTotal = 0.0;
      listProducts = [];
      listPackages = [];
    });

    listCarrito.forEach((item) {
      double priceItem = 0.0; //para mostrar en la lista

      _priceTotal = _priceTotal + (item.quantity * item.price);
      priceItem = (item.quantity * item.price);

      item.extras.forEach((extra) {
        _priceTotal = _priceTotal + (extra.quantity * extra.price);
        priceItem = priceItem + (extra.quantity * extra.price);
      });

      String viewPriceItem = "${_pref.stg_coin}${priceItem.toStringAsFixed(2)}";

      if (item.type == "product") {
        listProducts.add(
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            leading: GlobalText(
              radius: 10,
              margin: 0,
              height: 60,
              width: 60,
              imgUrl: item.pic_selected,
              imgPlaceholder: "assets/img/kake.png",
            ),
            title: GlobalText(
              margin: 0,
              textTitle: item.name,
              textFontWeight: FontWeight.w500,
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GlobalText(
                  background: Color(0xFFEFEFEF),
                  marginTop: 5,
                  marginLeft: 0,
                  marginRight: 5,
                  marginBottom: 0,
                  paddingTop: 3,
                  paddingBottom: 3,
                  paddingLeft: 5,
                  paddingRight: 5,
                  radius: 5,
                  textTitle: "${item.quantity}",
                ),
                item.extras.length > 0
                    ? GlobalText(
                        marginTop: 5,
                        marginLeft: 0,
                        marginRight: 0,
                        marginBottom: 0,
                        textTitle: " ${item.extras.length} Extras",
                        textColor: Config.colorTextAccent,
                      )
                    : SizedBox(),
              ],
            ),
            trailing: GlobalText(
              margin: 0,
              textTitle: viewPriceItem,
            ),
            onTap: () => openProduct(item),
          ),
        );
      } else {
        listPackages.add(
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            leading: GlobalText(
              radius: 10,
              margin: 0,
              height: 60,
              width: 60,
              imgUrl: item.pic_selected,
              imgPlaceholder: "assets/img/kake.png",
            ),
            title: GlobalText(
              margin: 0,
              textTitle: item.name,
              textFontWeight: FontWeight.w500,
            ),
            subtitle: GlobalText(
              alignment: Alignment.centerLeft,
              background: Color(0xFFEFEFEF),
              marginTop: 5,
              marginLeft: 0,
              marginRight: 5,
              marginBottom: 0,
              paddingTop: 3,
              paddingBottom: 3,
              paddingLeft: 5,
              paddingRight: 5,
              radius: 5,
              textTitle: "${item.quantity}",
            ),
            trailing: GlobalText(
              margin: 0,
              textTitle: viewPriceItem,
            ),
            onTap: () => openPackage(item),
          ),
        );
      }
    });
  }

  void _callback(List<Carrito> response) {
    double price = 0.0;

    response.forEach((item) {
      price = price + (item.quantity * item.price);

      item.extras.forEach((extra) {
        price = price + (extra.quantity * extra.price);
      });
    });

    setState(() {
      _priceTotal = price;
      listCarrito = response;
    });
    _verify();
  }

  void openProduct(Carrito c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VProduct(c.id, listCarrito),
      ),
    ).then((response) => _callback(response));
  }

  void openPackage(Carrito c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VPackage(c.id, listCarrito),
      ),
    ).then((response) => _callback(response));
  }

  void openPayment() {
    if (_priceTotal >= 20) {
      /*Pref pref1 = Pref();
      print(pref1.stg_time_close);
      var updatedAt = DateTime.parse(data['updated_at']);
      print(horita.hour.toInt);
      int hurr = horita.hour.toInt();
      print(hurr);
      if ((horita.hour.toInt >= 8) {
        print("entro por k es asado las 8")
        if (hurr <= 22) {
          print("puede comprar");
        }else{
          print("hora fuera de rango");
        }
      }*/
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VPayment(listCarrito),
        ),
      ).then((response) {
        setState(() => listCarrito = response);
        _verify();
      });
    } else {
      _modal.show(context, "El Pedido mayor S/. 20.0", " ATENCION!!!!  ");
    }
  }

  void _clearCarShop(title, description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Aceptar"),
              onPressed: () {
                setState(() {
                  listCarrito = [];
                  _priceTotal = 0.0;
                });
                _modal.toast("Eliminado correctamente");
                Navigator.of(context).pop();
                Navigator.pop(context, listCarrito);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _pref.init().then((value) {
      setState(() {
        _pref = value;
      });
    });
    _verify();
  }

  @override
  Widget build(BuildContext context) {
    String viewCostProducts =
        "${_pref.stg_coin}${_priceTotal.toStringAsFixed(2)}";
    String viewDelivery = "${_pref.stg_coin}${_delivery.toStringAsFixed(2)}";
    String viewPriceTotal =
        "${_pref.stg_coin}${(_priceTotal + _delivery).toStringAsFixed(2)}";

    final viewInformation = Container(
      color: Colors.white,
      width: Config.width(context),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GlobalText(
                textTitle: "Costo de productos",
              ),
              GlobalText(
                marginTop: 0,
                textTitle: viewCostProducts,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GlobalText(
                marginTop: 0,
                textTitle: "Costo de envío",
              ),
              GlobalText(
                marginTop: 0,
                textTitle: viewDelivery,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GlobalText(
                marginTop: 0,
                textTitle: "Total a cobrar",
                textFontWeight: FontWeight.w500,
                textColor: Config.colorTextBold,
                textFontSize: 18,
              ),
              GlobalText(
                marginTop: 0,
                textTitle: viewPriceTotal,
                textFontWeight: FontWeight.w500,
                textColor: Config.colorTextBold,
                textFontSize: 18,
              )
            ],
          ),
        ],
      ),
    );

    final viewProducts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GlobalText(
          textTitle: "Productos",
          textFontSize: 18,
          textFontWeight: FontWeight.w500,
        ),
        Material(
          color: Colors.white.withOpacity(0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listProducts,
          ),
        ),
      ],
    );

    final viewPackages = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GlobalText(
          textTitle: "Paquetes",
          textFontSize: 18,
          textFontWeight: FontWeight.w500,
        ),
        Material(
          color: Colors.white.withOpacity(0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listPackages,
          ),
        ),
      ],
    );

    final viewContinue = Positioned(
      bottom: 0,
      child: GlobalText(
        width: Config.width(context),
        height: 50,
        margin: 0,
        background: Config.colorPrimary,
        textTitle: "Continuar",
        textColor: Colors.white,
        textFontSize: 16,
        textFontWeight: FontWeight.w500,
        alignmentContent: Alignment.center,
        callback: openPayment,
      ),
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, listCarrito);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Config.colorPrimary,
          title: Text("Pedido"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, listCarrito);
            },
          ),
          actions: <Widget>[
            Container(
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Icon(Icons.remove_shopping_cart, color: Colors.white),
                ),
                onTap: () => _clearCarShop(
                    "Espera!", "¿Seguro quieres eliminar tu pedido?"),
              ),
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                viewInformation,
                listProducts.length > 0 ? viewProducts : SizedBox(height: 0),
                listPackages.length > 0 ? viewPackages : SizedBox(height: 0),
                SizedBox(height: 50),
              ],
            ),
            viewContinue
          ],
        ),
      ),
    );
  }
}
