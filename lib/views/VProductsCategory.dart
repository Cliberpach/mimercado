import 'package:anvic/beans/carrito.dart';
import 'package:anvic/beans/category.dart';
import 'package:anvic/beans/package.dart';
import 'package:anvic/beans/pic.dart';
import 'package:anvic/beans/product.dart';
import 'package:anvic/util/pref.dart';
import 'package:anvic/util/util.dart';
import 'package:anvic/views/VCarShop.dart';
import 'package:anvic/views/VPackage.dart';
import 'package:anvic/views/VProduct.dart';
import 'package:anvic/views/VProducts.dart';
import 'package:anvic/widgets/widget_car.dart';
import 'package:anvic/widgets/widget_category.dart';
import 'package:anvic/widgets/widget_produt_grid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:anvic/util/Config.dart';
import 'package:anvic/widgets/global_text.dart';
import 'package:flutter/services.dart';
import '../models/globalSlides.dart';

class VProductsCategory extends StatefulWidget {
  Category category;
  List<Carrito> listCarrito;

  VProductsCategory({
    Key key,
    @override this.category,
    @override this.listCarrito,
  });

  @override
  _VProductsCategoryState createState() => _VProductsCategoryState();
}

class _VProductsCategoryState extends State<VProductsCategory> {
  Util util = Util();
  Pref pref = Pref();
  WidgetCar widgetCar = WidgetCar();

  GlobalSlides slides = GlobalSlides();

  final refresh = GlobalKey<RefreshIndicatorState>();
  final queryController = TextEditingController();
  FocusNode queryFocus = FocusNode();

  int quantity = 0;
  double priceTotal = 0.0;

  bool loading = false;
  String loadingTitle = "";
  String loadingMessage = "";
  String error = "";
  bool empty = false;

  List<Widget> listProducts = List();

  Future<Null> getProducts() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      listProducts = [];
      empty = false;
      loading = true;
      loadingTitle = "Cargando productos...";
    });
    try {
      final response =
          await http.post("${util.BASE_URL}/categories/product", body: {
        "token": pref.client_token,
        "id": widget.category.id.toString(),
      });

      var rsp = json.decode(response.body);

      if (rsp["ok"]) {
        rsp["items"].asMap().forEach((i, item) {
          Product product = Product();
          product.id = int.parse(item["id"]);
          product.name = item["name"];
          product.description = item["description"];
          product.price = double.parse(item["price"]);

          item["pics"].asMap().forEach((i, item) {
            product.pics.add(
              Pic(pic_small: item["pic_small"], pic_large: item["pic_large"]),
            );
          });

          listProducts.add(
            WidgetProductGrid(
              colorOne: Color(0xFFDFDFDF),
              colorTwo: Color(0xFFDFDFDF),
              imgUrl: product.pics.length > 0 ? product.pics[0].pic_large : "",
              imgPlaceholder: 'assets/img/kake.png',
              title: product.name,
              description: product.description,
              floating: "${pref.stg_coin}${product.price.toStringAsFixed(2)}",
              callback: () => openProduct(product),
            ),
          );
        });
      }
    } catch (e) {
      print("Error:: $e");
    }
    setState(() {
      loading = false;
      loadingTitle = "";
      empty = listProducts.length == 0 ? true : false;
    });
  }

  openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VProduct(product.id, widget.listCarrito),
      ),
    ).then((response) => callback(response));
  }

  openCarShop() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VCarShop(widget.listCarrito),
      ),
    ).then((response) => callback(response));
  }

  callback(response) {
    double price = 0.0;

    response.forEach((item) {
      price = price + (item.quantity * item.price);

      item.extras.forEach((extra) {
        price = price + (extra.quantity * extra.price);
      });
    });

    setState(() {
      quantity = response.length;
      priceTotal = price;
      widget.listCarrito = response;
    });
  }

  verify() {
    quantity = widget.listCarrito.length;

    double price = 0.0;

    widget.listCarrito.forEach((item) {
      price = price + (item.quantity * item.price);

      item.extras.forEach((extra) {
        price = price + (extra.quantity * extra.price);
      });
    });

    setState(() {
      priceTotal = price;
    });
  }

  Future<Null> loadData() {
    return getProducts().then((rsp) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    pref.init().then((value) {
      setState(() {
        pref = value;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refresh.currentState.show();
    });
    verify();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Config.colorPrimary),
    );

    final viewEmpty = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GlobalText(
            marginTop: 0,
            marginBottom: 0,
            textTitle: "No se encontraron resultados",
            textFontWeight: FontWeight.w500,
            textSoftWrap: true,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    final viewProducts = Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GridView.count(
        crossAxisCount: 2,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: listProducts,
      ),
    );

    final viewResult = SafeArea(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          listProducts.length > 0 ? viewProducts : SizedBox(),
          SizedBox(height: widget.listCarrito.length > 0 ? 70 : 0),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, widget.listCarrito);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(util.primaryColor),
          title: Text(widget.category.name),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, widget.listCarrito);
            },
          ),
        ),
        body: RefreshIndicator(
          key: refresh,
          onRefresh: loadData,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: <Widget>[
                viewResult,
                widget.listCarrito.length > 0
                    ? widgetCar.carShop(
                        context,
                        quantity,
                        priceTotal,
                        openCarShop,
                      )
                    : SizedBox(),
                empty ? viewEmpty : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
