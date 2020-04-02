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
import 'package:anvic/views/VProductsCategory.dart';
import 'package:anvic/views/VSearch.dart';
import 'package:anvic/widgets/drawer.dart';
import 'package:anvic/widgets/modal.dart';
import 'package:anvic/widgets/widget_car.dart';
import 'package:anvic/widgets/widget_category.dart';
import 'package:anvic/widgets/widget_product.dart';
import 'package:anvic/widgets/widget_produt_grid.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:anvic/util/Config.dart';
import 'package:anvic/widgets/global_text.dart';
import 'package:flutter/services.dart';
import '../models/globalSlides.dart';

class VHome extends StatefulWidget {
  @override
  _VHomeState createState() => _VHomeState();
}

class _VHomeState extends State<VHome> {
  Util util = Util();
  Pref pref = Pref();
  Modal modal = Modal();
  WidgetCar widgetCar = WidgetCar();

  GlobalSlides slides = GlobalSlides();

  final refresh = GlobalKey<RefreshIndicatorState>();
  final queryController = TextEditingController();
  FocusNode queryFocus = FocusNode();

  List<Carrito> listCarrito = [];
  int quantity = 0;
  double priceTotal = 0.0;

  bool loading = false;
  String loadingTitle = "";
  String loadingMessage = "";
  String error = "";
  bool empty = false;

  List<Widget> listPackages = List();
  List<Widget> listCategories = List();
  List<Widget> listProducts = List();

  Future<Null> getProducts() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      listPackages = [];
      listCategories = [];
      listProducts = [];
      empty = false;
      loading = true;
      loadingTitle = "";
    });
    try {
      final response = await http.post("${util.BASE_URL}/home", body: {
        "token": pref.client_token,
      });

      var rsp = json.decode(response.body);

      if (rsp["ok"]) {
        rsp["packages"].asMap().forEach((i, item) {
          Package package = Package();
          package.id = int.parse(item["id"]);
          package.name = item["name"];
          package.description = item["description"];
          package.price = double.parse(item["price"]);
          package.pic_small = item["pic_small"];
          package.pic_large = item["pic_large"];
          listPackages.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                i == 0 ? SizedBox(width: 10.0) : SizedBox(),
                slides.slideOne(
                  height: 120.0,
                  width: 300.0,
                  radius: 10.0,
                  img: package.pic_large,
                  evt: () => openPackage(package),
                ),
                SizedBox(width: 10.0),
              ],
            ),
          );
        });

        rsp["categories"].asMap().forEach((i, item) {
          Category category = Category();
          category.id = int.parse(item["id"]);
          category.name = item["name"];
          category.pic_small = item["pic_small"];
          category.pic_large = item["pic_large"];

          listCategories.add(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: GlobalText(
                    margin: 0,
                    radius: 10,
                    imgUrl: category.pic_large,
                    imgPlaceholder: 'assets/img/kake.png',
                    imgWidth: 60,
                    imgHeight: 60,
                  ),
                  title: GlobalText(
                    margin: 0,
                    textTitle: category.name,
                    textFontWeight: FontWeight.w500,
                  ),
                  trailing: GlobalText(
                    icon: Icon(
                      Icons.keyboard_arrow_right,
                      color: Config.colorText,
                    ),
                  ),
                  onTap: () => openProductsCategory(category),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(height: 0.0),
                ),
              ],
            ),
          );
        });

        rsp["products"].asMap().forEach((i, item) {
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

          // if (product.pics.length > 0)
          listProducts.add(
            Container(
              width: MediaQuery.of(context).size.width,
              
              child: WidgetProduct(
                imgUrl:
                    product.pics.length > 0 ? product.pics[0].pic_large : "",
                imgPlaceholder: 'assets/img/kake.png',
                title: product.name,
                
                description: product.description,
                floating: "${pref.stg_coin}${product.price.toStringAsFixed(2)}",
                callback: () => openProduct(product),
              ),
            ),
          );
        });
      }
    } catch (e) {
      modal.show(context, "Ups...", "Ocurrio un error.");
      print("Error:: $e");
    }
    setState(() {
      loading = false;
      loadingTitle = "";
      empty = listPackages.length == 0 &&
              listCategories.length == 0 &&
              listProducts.length == 0
          ? true
          : false;
    });
  }

  void openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VSearch(
          listCarrito: listCarrito,
        ),
      ),
    ).then((response) => callback(response));
  }

  void openProductsCategory(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VProductsCategory(
          category: category,
          listCarrito: listCarrito,
        ),
      ),
    ).then((response) => callback(response));
  }

  openCategory(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VProducts(category, listCarrito),
      ),
    ).then((response) => callback(response));
  }

  openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VProduct(product.id, listCarrito),
      ),
    ).then((response) => callback(response));
  }

  openPackage(Package package) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VPackage(package.id, listCarrito),
      ),
    ).then((response) => callback(response));
  }

  openCarShop() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VCarShop(listCarrito),
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
      listCarrito = response;
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

    final viewPackages = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GlobalText(
          textTitle: "Promociones",
          textColor: Config.colorPrimary,
          textFontSize: 18,
          textFontWeight: FontWeight.w500,
        ),
        Container(
          height: 120.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[Row(children: listPackages)],
          ),
        ),
      ],
    );

    final viewCategories = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GlobalText(
          textTitle: "Catálogo",
          textColor: Config.colorPrimary,
          textFontSize: 18,
          textFontWeight: FontWeight.w500,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: listCategories,
        ),
      ],
    );

    // replace with slider
    // final viewProducts = Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     Container(
    //       margin: EdgeInsets.only(top: 10),
    //       padding: EdgeInsets.symmetric(horizontal: 5.0),
    //       height: 120,
    //       child: ListView(
    //         scrollDirection: Axis.horizontal,
    //         shrinkWrap: true,
    //         children: <Widget>[
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: listProducts,
    //           ),
    //         ],
    //       ),
    //     )
    //   ],
    // );

    final viewProducts = CarouselSlider(
      height: 200.0,
      aspectRatio: 1.0,
      viewportFraction: 0.8,
      autoPlay: true,
      initialPage: 0,
      enableInfiniteScroll: true,
      items: listProducts,
       //items: [1, 2, 3, 4, 5].map((i) {
       //  return Builder(
       //    builder: (BuildContext context) {
       //      return Container(
       //          width: MediaQuery.of(context).size.width,
       //          margin: EdgeInsets.symmetric(horizontal: 5.0),
       //         decoration: BoxDecoration(color: Colors.amber),
       //         child: Text(
       //            'text $i',
       //           style: TextStyle(fontSize: 16.0),
       //         ));
        //  },
      //  );
      // }).toList(),
    );
    final viewResult = SafeArea(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          listProducts.length > 0 ? viewProducts : SizedBox(),
          listPackages.length > 0 ? viewPackages : SizedBox(),
          listCategories.length > 0 ? viewCategories : SizedBox(),
          SizedBox(height: listCarrito.length > 0 ? 70 : 0),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () {
        listCarrito.length > 0
            ? modal.confirm(
                context,
                "SALIR",
                "Perderas los productos de tu canasta.",
                () => SystemNavigator.pop())
            : SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(util.primaryColor),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Color(util.whitePrimary)),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text("Inicio"),
          actions: <Widget>[
            GlobalText(
              icon: Icon(Icons.search),
              callback: () => openSearch(),
            )
          ],
        ),
        drawer: Drawer(
          child: DrawerMenu(),
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
                listCarrito.length > 0
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
