import 'package:anvic/util/Config.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../util/pref.dart';
import '../util/util.dart';
import '../widgets/modal.dart';
import '../beans/product.dart';
import '../beans/variation.dart';
import '../beans/carrito.dart';
import '../beans/pic.dart';
import '../views/VGalleryProduct.dart';
import '../views/VSelectVariation.dart';
import '../models/add_product_modal.dart';
import '../widgets/global_text.dart';
import '../models/globalButtons.dart';
import '../models/globalAlerts.dart';

class VProduct extends StatefulWidget {
  int idProduct;
  List<Carrito> listCarrito;

  VProduct(this.idProduct, this.listCarrito);

  // ******************************************
  @override
  _VProductState createState() => _VProductState(idProduct, listCarrito);
}

class _VProductState extends State<VProduct> {
  GlobalButtons globalButtons = GlobalButtons();
  GlobalAlerts globalAlerts = GlobalAlerts();
  CarouselSlider instance;
  int _current = 0;
  int initialPage = 0;

  int idProduct;
  List<Carrito> listCarrito;

  _VProductState(this.idProduct, this.listCarrito);

  // ******************************************

  final _refresh = GlobalKey<RefreshIndicatorState>();
  Product _product = Product();
  List<Product> _extras = List();
  List<Carrito> _listExtras = List();
  List<Widget> _extrasList = List();

  List<Variation> variations = List();
  List<Variation> listVariations = List();
  List<Widget> variationsList = List();

  var _listImage = [];

  Util _util = Util();
  Pref _pref = Pref();
  Modal _modal = Modal();
  bool _loading = true;
  Map _rsp;

  int _indexItem = -1;
  int _quantity = 0;
  double _priceTotal = 0.0;

  Future _getProduct() async {
    _extras = [];
    variations = [];
    _product.pics = [];

    try {
      setState(() => _loading = true);
      http.Response response = await http.post(
        "${_util.BASE_URL}/products/product",
        body: ({"token": "${_pref.client_token}", "id": "${idProduct}"}),
      );
      _rsp = jsonDecode(response.body);

      if (_rsp['ok']) {
        setState(() {
          _product.id = int.parse(_rsp["id"]);
          _product.name = _rsp["name"];
          _product.description = _rsp["description"];
          _product.apply_name = _rsp["apply_name"];
          _product.price = double.parse(_rsp["price"]);

          _quantity = 1;
          _priceTotal = double.parse(_rsp["price"]);
        });

        _rsp["pics"].asMap().forEach((i, item) {
          print(item["id"]);
          _product.pics.add(
              Pic(pic_small: item["pic_small"], pic_large: item["pic_large"]));
        });

        for (int i = 0; i < _rsp["extras"].length; i++) {
          Product p = Product();
          p.id = int.parse(_rsp["extras"][i]["id"]);
          p.name = _rsp["extras"][i]["name"];
          p.description = _rsp["extras"][i]["description"];
          p.apply_name = _rsp["extras"][i]["apply_name"];
          p.price = double.parse(_rsp["extras"][i]["price"]);

          p.pics.add(Pic(
              pic_small: _rsp["extras"][i]["pic_small"],
              pic_large: _rsp["extras"][i]["pic_large"]));

          _extras.add(p);
        }

        _rsp["variations"].forEach((item) {
          Variation variation = Variation();
          variation.id = int.parse(item["id"]);
          variation.name = item["name"];
          variation.description = item["description"];
          variation.required = int.parse(item["required"]);
          variation.apply = int.parse(item["apply"]);

          item["items"].forEach((item2) {
            Variation variation2 = Variation();
            variation2.id = int.parse(item2["id"]);
            variation2.name = item2["name"];
            variation2.pic = Pic(
                pic_small: item2["pic_small"], pic_large: item2["pic_large"]);
            variation.items.add(variation2);
          });

          variations.add(variation);
        });

        _fillExtras();
        _verifyExist();
        fillVariations();
      } else {
        print("Ocurrio un error.");
      }
      setState(() => _loading = false);
    } catch (e) {
      _modal.show(context, "Ups...", "No tienes conectividad.");
      print("error $e");
    }
  }

  void fillVariations() {
    print("Fill variation");
    variationsList = [];

    variations.forEach((variation) {
      listVariations.forEach((item) {
        if (item.id == variation.id) {
          int positionVariation = variations.indexOf(variation);
          variations.removeAt(positionVariation);
          variations.insert(positionVariation, item);
          variation = item;
        }
      });

      variationsList.add(
        variation.apply == 0
            ? ListTile(
                title: GlobalText(
                  margin: 0,
                  textTitle: variation.name,
                  textFontWeight: FontWeight.w500,
                ),
                subtitle: variation.select != null
                    ? GlobalText(
                        textTitle: variation.select.name,
                        textColor: Config.colorTextAccent,
                        marginTop: 0,
                        marginLeft: 0,
                      )
                    : null,
                trailing: GlobalText(
                  margin: 0,
                  icon: Icon(
                    Icons.keyboard_arrow_right,
                    color: Config.colorTextAccent,
                  ),
                ),
                onTap: () => openSelectVariation(variation),
              )
            : ListTile(
                title: GlobalText(
                  margin: 0,
                  textTitle: variation.name,
                  textFontWeight: FontWeight.w500,
                  textSoftWrap: true,
                ),
                subtitle: variation.apply_name != ""
                    ? GlobalText(
                        textTitle: variation.apply_name,
                        textColor: Config.colorTextAccent,
                        marginTop: 0,
                        marginLeft: 0,
                      )
                    : null,
                trailing: GlobalText(
                  margin: 0,
                  icon: Icon(
                    Icons.touch_app,
                    color: Config.colorTextAccent,
                  ),
                ),
                onTap: () => openApplyVariation(variation),
              ),
      );
    });
  }

  Future _asyncInputDialog(BuildContext context, Variation variation) async {
    final textController = TextEditingController();
    textController.text = variation.apply_name;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.done,
                  autofocus: true,
                  controller: textController,
                  decoration: InputDecoration(
                      labelText: variation.name, hintText: 'Respuesta'),
                  onEditingComplete: () {
                    print("Complete");
                    variation.apply_name = textController.text;
                    Navigator.of(context).pop(variation);
                  },
                ),
              )
            ],
          ),
          actions: <Widget>[
            variation.required == 0
                ? FlatButton(
                    child: Text(
                      'Eliminar',
                      style: TextStyle(color: Config.colorDanger),
                    ),
                    onPressed: () {
                      variation.apply_name = "";
                      Navigator.of(context).pop(variation);
                    },
                  )
                : SizedBox(),
            FlatButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Config.colorTextAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop("cancel");
              },
            ),
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
                variation.apply_name = textController.text;
                Navigator.of(context).pop(variation);
              },
            ),
          ],
        );
      },
    );
  }

  void openApplyVariation(Variation variation) {
    _asyncInputDialog(context, variation).then((response) {
      if (response == "cancel") {
      } else {
        int position = null;

        listVariations.forEach((item) {
          if (item.id == response.id) {
            position = listVariations.indexOf(item);
          }
        });

        if (response.apply_name != "") {
          if (position != null) {
            listVariations.removeAt(position);
            listVariations.insert(position, response);
          } else {
            listVariations.add(response);
          }
        } else {
          listVariations.removeAt(position);
        }
        fillVariations();
      }
    });
  }

  void openSelectVariation(Variation variation) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VSelectVariation(variation: variation)))
        .then((response) {
      int position = null;

      listVariations.forEach((item) {
        if (item.id == response.id) {
          position = listVariations.indexOf(item);
        }
      });

      if (response.select != null) {
        if (position != null) {
          listVariations.removeAt(position);
          listVariations.insert(position, response);
        } else {
          listVariations.add(response);
        }
      } else {
        listVariations.removeAt(position);
      }

      fillVariations();
    });
  }

  void _fillExtras() {
    _extrasList = [];
    _extras.forEach((pro) {
      Carrito carrito = Carrito();
      carrito.type = 'product';
      carrito.id = pro.id;
      carrito.name = pro.name;
      carrito.price = pro.price;
      carrito.apply_name = pro.apply_name;
      carrito.pic_selected = pro.pics.length > 0 ? pro.pics[0].pic_large : "";

      bool exist = false;
      int position = -1;

      _listExtras.forEach((item) {
        if (item.id == carrito.id) {
          exist = true;
          position = _listExtras.indexOf(item);
          carrito = _listExtras[position];
        }
      });

      String fillPrice = "";
      String fillName = "";

      if (carrito.quantity > 0) {
        fillPrice =
            "${_pref.stg_coin}${(carrito.price * carrito.quantity).toStringAsFixed(2)}";
        fillName = "${carrito.name} (${carrito.quantity})";
      } else {
        fillPrice = "${_pref.stg_coin}${carrito.price.toStringAsFixed(2)}";
        fillName = "${carrito.name}";
      }

      _extrasList.add(
        InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          exist
                              ? Container(
                                  width: 25.0,
                                  height: 25.0,
                                  child: Icon(
                                    Icons.check_box,
                                    color: Color(_util.greenPrimary),
                                    size: 25.0,
                                  ))
                              : Container(
                                  width: 25.0,
                                  height: 25.0,
                                  child: Icon(
                                    Icons.check_box_outline_blank,
                                    color: Color(_util.colorFor),
                                    size: 25.0,
                                  ),
                                ),
                          Container(
                            width: MediaQuery.of(context).size.width - 140,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              fillName,
                              style: TextStyle(
                                  color: Color(_util.texto),
                                  fontFamily: "GeoReg",
                                  fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    carrito.price > 0
                        ? GlobalText(
                            textTitle: fillPrice,
                          )
                        : GlobalText(
                            textTitle: "GRATIS",
                            textColor: Color(_util.greenPrimary),
                          )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(height: 0.0),
              )
            ],
          ),
          onTap: () => _changeExtra(carrito),
        ),
      );
    });
  }

  void _changeExtra(Carrito carrito) {
    bool exist = false;
    int position = -1;
    double priceTotal = 0.0;

    _listExtras.forEach((item) {
      if (item.id == carrito.id) {
        exist = true;
        position = _listExtras.indexOf(item);
        carrito = _listExtras[position];
      }
    });

    priceTotal = (carrito.quantity * carrito.price);

    if (carrito.price > 0) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return AddProductModal((response) {
              carrito = response;
              if (exist) {
                setState(() {
                  _listExtras.removeAt(position);
                  _listExtras.insert(position, carrito);
                });
              } else {
                setState(() {
                  _listExtras.add(carrito);
                });
              }

              setState(() {
                _priceTotal = (_priceTotal - priceTotal) +
                    (carrito.quantity * carrito.price);
              });

              _fillExtras();
            }, () {
              if (exist) {
                setState(() {
                  _listExtras.removeAt(position);
                  _priceTotal = (_priceTotal - priceTotal);
                });
                _fillExtras();
              }
            }, carrito);
          });
    } else {
      if (exist) {
        setState(() {
          _listExtras.removeAt(position);
        });
      } else {
        setState(() {
          carrito.quantity = 1;
          _listExtras.add(carrito);
        });
      }
      _fillExtras();
    }
  }

  nextSlider() {
    instance.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  prevSlider() {
    instance.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  Future<Null> loadData() {
    return _getProduct().then((rsp) {
      setState(() {});
    });
  }

  void _verifyExist() {
    listCarrito.forEach((item) {
      if (item.type == "product" && item.id == _product.id) {
        double price = 0.0;

        price = price + (item.quantity * item.price);

        item.extras.forEach((extra) {
          _listExtras.add(extra);
          price = price + (extra.quantity * extra.price);
        });

        setState(() {
          listVariations = item.variations;
          _indexItem = listCarrito.indexOf(item);
          _quantity = item.quantity;
          _priceTotal = price;
          initialPage = item.indexPic;
          _current = item.indexPic;
        });
      }
    });

    _fillExtras();
  }

  void _addItemCarrito() {
    String message = "";
    int total = 0;
    String prefix = "El campo";
    String suffix = "es requerido.";

    variations.asMap().forEach((i, variation) {
      if (variation.required == 1) {
        if (variation.apply == 0 && variation.select == null) {
          message += "${variation.name}, ";
          total++;
        } else if (variation.apply == 1 && variation.apply_name.isEmpty) {
          message += "${variation.name}, ";
          total++;
        }
      }
    });

    if (message.length > 4) {
      message = message.substring(0, (message.length - 2));
    }

    if (total > 1) {
      prefix = prefix = "Los campos:";
      suffix = " son requeridos.";
    }

    if (message != "") {
      globalAlerts.alertOne(context,
          title: "Espera", description: "$prefix $message $suffix");
    } else {
      Carrito c = Carrito();
      c.type = 'product';
      c.id = _product.id;
      c.name = _product.name;
      c.quantity = _quantity;
      c.price = _product.price;
      c.pic_selected =
          _product.pics.length > 0 ? _product.pics[_current].pic_large : "";
      c.indexPic = _current;
      c.variations = listVariations;
      c.extras = _listExtras;

      if (_indexItem >= 0) {
        listCarrito.removeAt(_indexItem);
        listCarrito.insert(_indexItem, c);
      } else {
        listCarrito.add(c);
      }

      Navigator.pop(context, listCarrito);
    }
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
      _priceTotal = _priceTotal + _product.price;
    });
  }

  void _subtractQuantity() {
    if (_indexItem >= 0) {
      if (_quantity > 0) {
        setState(() {
          _quantity--;
          _priceTotal = _priceTotal - _product.price;
        });
      }
    } else {
      if (_quantity > 1) {
        setState(() {
          _quantity--;
          _priceTotal = _priceTotal - _product.price;
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
    instance = CarouselSlider(
      viewportFraction: 1.0,
      height: 250.0,
      autoPlay: false,
      enableInfiniteScroll: false,
      initialPage: initialPage,
      onPageChanged: (index) {
        if (initialPage != 0) {
          if (index == (_product.pics.length - 1)) {
            setState(() {
              initialPage = 0;
              _current = (_current - 1);
            });
          } else if (index == 1) {
            setState(() {
              initialPage = 0;
              _current = (_current + 1);
            });
          }
        } else {
          setState(() {
            _current = index;
          });
        }
      },
      items: _product.pics.map((pic) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(pic.pic_large), fit: BoxFit.cover),
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VGalleryProduct(pics: _product.pics),
                ),
              ),
            );
          },
        );
      }).toList(),
    );

    final picsProduct = SizedBox(
      height: 250,
      child: Stack(children: [
        instance,
        Positioned(
          left: 0,
          top: 100,
          child: GlobalText(
            margin: 0,
            height: 50,
            width: 30,
            background: Colors.black.withOpacity(0.2),
            alignmentContent: Alignment.center,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
            callback: prevSlider,
          ),
        ),
        Positioned(
          right: 0,
          top: 100,
          child: GlobalText(
            margin: 0,
            height: 50,
            width: 30,
            background: Colors.black.withOpacity(0.2),
            alignmentContent: Alignment.center,
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
            callback: nextSlider,
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _product.pics.map((item) {
              var index = _product.pics.indexOf(item);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Colors.white.withOpacity(0.9)
                      : Colors.white.withOpacity(0.4),
                ),
              );
            }).toList(),
          ),
        ),
      ]),
    );

    final detailProduct = Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _product.name.isNotEmpty
              ? GlobalText(
                  marginTop: 20,
                  marginBottom: 20,
                  marginLeft: 0,
                  marginRight: 0,
                  textTitle: _product.name,
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
          _product.description.isNotEmpty
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
                      textTitle: _product.description,
                      textColor: Config.colorTextAccent,
                      textSoftWrap: true,
                    )
                  ],
                )
              : SizedBox(height: 20),
        ],
      ),
    );

    final variationsView = Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Material(
        color: Colors.white,
        child: Container(
          child: Column(children: variationsList),
        ),
      ),
    );

    final extrasView = _extrasList.length > 0
        ? Container(
            margin: EdgeInsets.only(top: 10.0),
            padding: EdgeInsets.all(10.0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GlobalText(
                      textTitle: "Extras",
                      textFontSize: 18.0,
                      textColor: Config.colorTextBold,
                      textFontWeight: FontWeight.w500,
                      marginBottom: 0,
                    ),
                  ],
                ),
                Column(children: _extrasList)
              ],
            ),
          )
        : SizedBox();

    final addCarShop = Positioned(
      bottom: 0.0,
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
                          ? "${_pref.stg_coin}${_priceTotal.toStringAsFixed(2)}"
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

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, listCarrito);
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Color(_util.colorSeven),
          appBar: AppBar(
            backgroundColor: Color(_util.primaryColor),
            title: Text(_product.name),
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
                          _product.pics.length > 0
                              ? picsProduct
                              : SizedBox(height: 0.0),
                          detailProduct,
                          variationsView,
                          extrasView,
                          SizedBox(height: 50.0)
                        ],
                      ),
                      addCarShop
                    ],
                  )
                : ListView(),
          ),
        ),
      ),
    );
  }
}
