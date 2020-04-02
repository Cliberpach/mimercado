import 'package:anvic/util/Config.dart';
import 'package:anvic/widgets/global_text.dart';
import 'package:anvic/widgets/widget_produt_grid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import '../util/pref.dart';
import '../util/util.dart';
import '../widgets/modal.dart';
import '../beans/product.dart';
import '../beans/package.dart';
import '../beans/pic.dart';
import '../beans/carrito.dart';
import '../views/VGalleryProduct.dart';

class VPackage extends StatefulWidget {
  int idPackage;
  List<Carrito> listCarrito;

  VPackage(this.idPackage, this.listCarrito);

  // ******************************************
  @override
  _VPackageState createState() => _VPackageState(idPackage, listCarrito);
}

class _VPackageState extends State<VPackage> {
  int idPackage;
  List<Carrito> listCarrito;

  _VPackageState(this.idPackage, this.listCarrito);

  // ******************************************

  final _refresh = GlobalKey<RefreshIndicatorState>();
  Package _package = Package();
  Util _util = Util();
  Pref _pref = Pref();
  Modal _modal = Modal();
  bool _loading = true;
  Map _rsp;
  int _indexItem = -1;
  int _quantity = 0;
  double _priceTotal = 0.0;
  var contiene = [];

  List<Widget> listProducts = List();

  Future _getPackage() async {
    setState(() {
      listProducts = [];
    });
    try {
      
      setState(() => _loading = true);
      http.Response response = await http.post(
          "${_util.BASE_URL}/packages/package/$idPackage",
          body: ({"token": "${_pref.client_token}"}));
      _rsp = jsonDecode(response.body);

      print(_rsp);

      if (_rsp['ok']) {
        setState(() {
          _package.id = int.parse(_rsp["id"]);
          _package.name = _rsp["name"];
          _package.description = _rsp["description"];
          _package.price = double.parse(_rsp["price"]);
          _package.pic_small = _rsp["pic_small"];
          _package.pic_large = _rsp["pic_large"];

          _quantity = 1;
          _priceTotal = double.parse(_rsp["price"]);
        });

        for (int i = 0; i < _rsp["products"].length; i++) {
          Product product = Product();
          product.id = int.parse(_rsp["products"][i]["id"]);
          product.name = _rsp["products"][i]["name"];
          product.description = _rsp["products"][i]["description"];
          product.price = double.parse(_rsp["products"][i]["price"]);

          _rsp["products"][i]["pics"].asMap().forEach((i, item) {
            product.pics.add(Pic(
                pic_small: item["pic_small"], pic_large: item["pic_large"]));
          });

          listProducts.add(
            WidgetProductGrid(
              colorOne: Color(0xFFDFDFDF),
              colorTwo: Color(0xFFDFDFDF),
              imgUrl: product.pics.length > 0 ? product.pics[0].pic_large : "",
              imgPlaceholder: 'assets/img/kake.png',
              title: product.name,
              description: product.description,
              floating: "${_pref.stg_coin}${product.price.toStringAsFixed(2)}",
              callback: () => openGallery(product),
            ),
          );
        }
        _verifyExist();
      } else {
        print("Ocurrio un error.");
      }
      setState(() => _loading = false);
    } catch (e) {
      _modal.show(context, "Ups...", "No tienes conectividad.");
      print("error conexion $e");
    }
  }

  openGallery(Product product) {
    if (product.pics.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VGalleryProduct(pics: product.pics),
        ),
      );
    }
  }

  Future<Null> loadData() {
    return _getPackage().then((rsp) {
      setState(() {});
    });
  }

  void _verifyExist() {
    listCarrito.forEach((item) {
      if (item.type == "package" && item.id == _package.id) {
        double price = 0.0;

        price = price + (item.quantity * item.price);

        setState(() {
          _indexItem = listCarrito.indexOf(item);
          _quantity = item.quantity;
          _priceTotal = price;
        });
      }
    });
  }

  void _addItemCarrito() {
    Carrito c = Carrito();
    c.type = 'package';
    c.id = _package.id;
    c.name = _package.name;
    c.quantity = _quantity;
    c.price = _package.price;
    c.pic_selected = _package.pic_large;

    if (_indexItem >= 0) {
      listCarrito.removeAt(_indexItem);
      listCarrito.insert(_indexItem, c);
    } else {
      listCarrito.add(c);
    }

    Navigator.pop(context, listCarrito);
  }

  void _removeItemCarrito() {
    setState(() {
      listCarrito.removeAt(_indexItem);
    });
    Navigator.pop(context, listCarrito);
  }

  void _addQuantity() {
    setState(() {
      _quantity++;
      _priceTotal = _priceTotal + _package.price;
    });
  }

  void _subtractQuantity() {
    if (_indexItem >= 0) {
      if (_quantity > 0) {
        setState(() {
          _quantity--;
          _priceTotal = _priceTotal - _package.price;
        });
      }
    } else {
      if (_quantity > 1) {
        setState(() {
          _quantity--;
          _priceTotal = _priceTotal - _package.price;
        });
      }
    }

    print(_priceTotal);
  }

  @override
  void initState() {
    super.initState();
    _pref.init().then((value) {
      setState(() {
        _pref = value;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refresh.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailPackage = Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _package.name.isNotEmpty
              ? GlobalText(
                  marginTop: 20,
                  marginBottom: 20,
                  marginLeft: 0,
                  marginRight: 0,
                  textTitle: _package.name,
                  textFontSize: 18,
                  textFontWeight: FontWeight.w500,
                  textColor: Config.colorTextBold,
                  textSoftWrap: true,
                )
              : SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GlobalText(
                margin: 0,
                background: Config.colorPrimary,
                padding: 8,
                radius: 50,
                textTitle: _quantity.toString(),
                textColor: Colors.white,
                textFontWeight: FontWeight.w500,
                textFontSize: 20,
              ),
              Container(
                padding: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Config.colorPrimary),
                width: 110,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GlobalText(
                      margin: 0,
                      width: 50,
                      height: 30,
                      background: Colors.white,
                      radiusTopLeft: 50,
                      radiusBottomLeft: 50,
                      icon: Icon(
                        Icons.remove,
                        size: 30,
                        color: Config.colorPrimary,
                      ),
                      callback: _subtractQuantity,
                    ),
                    GlobalText(
                      margin: 0,
                      width: 50,
                      height: 30,
                      background: Config.colorPrimary,
                      radiusBottomRight: 50,
                      radiusTopRight: 50,
                      icon: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                      callback: _addQuantity,
                    ),
                  ],
                ),
              ),
            ],
          ),
          _package.description.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GlobalText(
                      marginTop: 20,
                      marginBottom: 0,
                      marginLeft: 0,
                      marginRight: 0,
                      textTitle: "Descripción",
                      textFontSize: 18.0,
                      textFontWeight: FontWeight.w500,
                    ),
                    GlobalText(
                      marginLeft: 0,
                      marginRight: 0,
                      marginBottom: 20,
                      textTitle: _package.description,
                      textColor: Config.colorTextAccent,
                      textSoftWrap: true,
                    )
                  ],
                )
              : SizedBox(height: 20),
        ],
      ),
    );

    final addCarShop = Positioned(
      bottom: 0,
      child: Material(
        color: Color(_util.primaryColor),
        child: Container(
            width: (MediaQuery.of(context).size.width),
            height: 50.0,
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      _indexItem >= 0
                          ? _quantity > 0 ? "Editar" : "Eliminar"
                          : "Agregar al carrito",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      _quantity > 0
                          ? "S/.${_priceTotal.toStringAsFixed(2)}"
                          : '',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              onTap: _quantity == 0 ? _removeItemCarrito : _addItemCarrito,
            )),
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: GridView.count(
            crossAxisCount: 2,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: listProducts,
          ),
        ),
      ],
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, listCarrito);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(_util.primaryColor),
          title: Text(_package.name),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, listCarrito);
            },
          ),
        ),
        body: RefreshIndicator(
          key: _refresh,
          onRefresh: loadData,
          child: !_loading
              ? Stack(
                  children: <Widget>[
                    ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        detailPackage,
                        listProducts.length > 0 ? viewProducts : SizedBox(),
                        SizedBox(height: 50.0)
                      ],
                    ),
                    addCarShop
                  ],
                )
              : ListView(),
        ),
      ),
    );
  }
}
