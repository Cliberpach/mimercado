import 'package:anvic/util/Config.dart';
import 'package:anvic/widgets/global_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../util/pref.dart';
import '../util/util.dart';
import '../widgets/widget_car.dart';
import '../beans/pic.dart';
import '../beans/category.dart';
import '../beans/product.dart';
import '../beans/carrito.dart';
import '../widgets/widget_produt_grid.dart';
import 'VProduct.dart';
import 'VCarShop.dart';

class VProducts extends StatefulWidget {
  Category category;
  List<Carrito> listCarrito;

  VProducts(this.category, this.listCarrito);

  @override
  _VProductsState createState() => _VProductsState(category, listCarrito);
}

class _VProductsState extends State<VProducts> {
  Category category;
  List<Carrito> listCarrito;

  _VProductsState(this.category, this.listCarrito);

  final _refresh = GlobalKey<RefreshIndicatorState>();

  Util _util = Util();
  Pref _pref = Pref();
  Map _rsp;
  WidgetCar _widgetCar = WidgetCar();
  List<Widget> listProducts = List();
  List<Widget> listProductsGrid = List();

  bool loading = false;

  int _quantity = 0;
  double _priceTotal = 0.0;

  void _verify() {
    _quantity = listCarrito.length;

    double price = 0.0;

    listCarrito.forEach((item) {
      price = price + (item.quantity * item.price);

      item.extras.forEach((extra) {
        price = price + (extra.quantity * extra.price);
      });
    });

    setState(() {
      _priceTotal = price;
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
      _quantity = response.length;
      _priceTotal = price;
      listCarrito = response;
    });
  }

  Future _getProducts() async {
    setState(() {
      loading = true;
      listProducts = [];
      listProductsGrid = [];
    });
    try {
      setState(() {
        loading = true;
      });
      http.Response response = await http.get(
          "${_util.BASE_URL}/categories/product?id=${category.id}&token=${_pref.client_token}");
      _rsp = jsonDecode(response.body);

      if (_rsp['ok']) {
        for (int i = 0; i < _rsp["items"].length; i++) {
          Product product = Product();
          product.id = int.parse(_rsp["items"][i]["id"]);
          product.name = _rsp["items"][i]["name"];
          product.description = _rsp["items"][i]["description"];
          product.price = double.parse(_rsp["items"][i]["price"]);

          _rsp["items"][i]["pics"].asMap().forEach((i, item) {
            product.pics.add(Pic(
                pic_small: item["pic_small"], pic_large: item["pic_large"]));
          });

          listProducts.add(
            Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: 'assets/img/kake.png',
                      image: product.pics.length > 0
                          ? product.pics[0].pic_large
                          : "",
                    ),
                  ),
                  title: GlobalText(
                    marginTop: 0,
                    textTitle: product.name,
                    textColor: Config.colorTextBold,
                  ),
                  subtitle: GlobalText(
                    textTitle: product.description,
                    textColor: Config.colorTextAccent,
                    marginTop: 0,
                  ),
                  trailing: GlobalText(
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                  onTap: () => openProduct(product),
                ),
                Divider(height: 0.0),
              ],
            ),
          );

          listProductsGrid.add(
            WidgetProductGrid(
              colorOne: Colors.black,
              colorTwo: Colors.black,
              imgUrl: product.pics.length > 0 ? product.pics[0].pic_large : "",
              imgPlaceholder: 'assets/img/kake.png',
              title: "Postres",
              description: "Deliciosos",
              floating: "S/10.00",
              callback: () {
                print("One");
              },
            ),
          );

        }

        print("Products: ${listProducts.length}");
        print("Products grid: ${listProductsGrid.length}");
      } else {}
    } catch (e) {
      print("Error:: $e");
    }
    setState(() {
      loading = false;
    });
  }

  void openProduct(Product product) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VProduct(product.id, listCarrito)))
        .then((response) => _callback(response));
  }

  void openCarShop() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => VCarShop(listCarrito)))
        .then((response) => _callback(response));
  }

  Future<Null> loadData() {
    return _getProducts().then((rsp) {
      setState(() {});
    });
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
    _verify();
  }

  @override
  Widget build(BuildContext context) {
    final viewProducts = Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: listProducts),
    );

    final productsGrid = Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GridView.count(
        crossAxisCount: 2,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: listProductsGrid,
      ),
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, listCarrito);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(_util.primaryColor),
          title: Text(category.name),
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
          child: Stack(
            children: <Widget>[
              ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  viewProducts,
                  productsGrid,
                  SizedBox(
                    height: listCarrito.length > 0 ? 70.0 : 0.0,
                  ),
                ],
              ),
              listCarrito.length > 0
                  ? _widgetCar.carShop(
                      context, _quantity, _priceTotal, openCarShop)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
