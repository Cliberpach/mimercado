import 'package:anvic/beans/carrito.dart';
import 'package:anvic/beans/category.dart';
import 'package:anvic/beans/package.dart';
import 'package:anvic/beans/pic.dart';
import 'package:anvic/beans/product.dart';
import 'package:anvic/util/pref.dart';
import 'package:anvic/util/util.dart';
import 'package:anvic/views/VPackage.dart';
import 'package:anvic/views/VProduct.dart';
import 'package:anvic/views/VProducts.dart';
import 'package:anvic/views/VProductsCategory.dart';
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

class VSearch extends StatefulWidget {
  List<Carrito> listCarrito;

  VSearch({Key key, @override this.listCarrito});

  @override
  _VSearchState createState() => _VSearchState();
}

class _VSearchState extends State<VSearch> {
  Util util = Util();
  Pref pref = Pref();

  GlobalSlides slides = GlobalSlides();

  final queryController = TextEditingController();
  FocusNode queryFocus = FocusNode();

  bool loading = false;
  String loadingTitle = "";
  String loadingMessage = "";
  String error = "";
  bool empty = false;

  List<Widget> listPackages = List();
  List<Widget> listCategories = List();
  List<Widget> listProducts = List();

  search() {
    String word = queryController.text.replaceFirst(new RegExp(r"^\s+"), "");
    if (word.isNotEmpty) {
      applySearch();
    }
  }

  Future<Null> applySearch() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      listPackages = [];
      listCategories = [];
      listProducts = [];
      empty = false;
      loading = true;
      loadingTitle = "Buscando...";
    });
    try {
      final response = await http.post("${util.BASE_URL}/home/search", body: {
        "token": pref.client_token,
        "word": queryController.text,
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
            WidgetCategory(
              imgUrl: category.pic_small,
              imgPlaceholder: 'assets/img/kake.png',
              title: category.name,
              callback: () => openProductsCategory(category),
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
      empty = listPackages.length == 0 &&
              listCategories.length == 0 &&
              listProducts.length == 0
          ? true
          : false;
    });
  }

  void openProductsCategory(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VProductsCategory(
          category: category,
          listCarrito: widget.listCarrito,
        ),
      ),
    ).then((response) => callback(response));
  }

  openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VProduct(product.id, widget.listCarrito),
      ),
    ).then((response) => callback(response));
  }

  openPackage(Package package) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VPackage(package.id, widget.listCarrito),
      ),
    ).then((response) => callback(response));
  }

  callback(response) {
    widget.listCarrito = response;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Config.colorPrimary),
    );

    final viewSearch = SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFDFDFDF).withOpacity(0.3),
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(
                0,
                0.6,
              ),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GlobalText(
              height: 55,
              width: 50,
              margin: 0,
              icon: Icon(Icons.arrow_back),
              callback: () => Navigator.pop(context, widget.listCarrito),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 110,
              height: 55,
              child: TextField(
                controller: queryController,
                focusNode: queryFocus,
                autofocus: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 18),
                  border: InputBorder.none,
                  hintText: 'Buscar...',
                ),
                onEditingComplete: search,
              ),
            ),
            GlobalText(
              height: 55,
              width: 50,
              margin: 0,
              icon: Icon(Icons.search),
              callback: search,
            ),
          ],
        ),
      ),
    );

    final viewLoading = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GlobalText(
            textTitle: loadingTitle,
            textFontWeight: FontWeight.w500,
          ),
          GlobalText(
            marginTop: 0,
            marginBottom: 0,
            textTitle: loadingMessage,
          ),
          SizedBox(child: CircularProgressIndicator()),
        ],
      ),
    );

    final viewEmpty = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GlobalText(
            textTitle: "No se encontraron resultados para",
            textFontWeight: FontWeight.w500,
          ),
          GlobalText(
            marginTop: 0,
            marginBottom: 0,
            textTitle: queryController.text,
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
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          height: 155,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: listCategories,
              ),
            ],
          ),
        )
      ],
    );

    final viewProducts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GlobalText(
          textTitle: "Productos",
          textColor: Config.colorPrimary,
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

    final viewResult = SafeArea(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SizedBox(height: 50),
          listCategories.length > 0 ? viewCategories : SizedBox(),
          listPackages.length > 0 ? viewPackages : SizedBox(),
          listProducts.length > 0 ? viewProducts : SizedBox(),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, widget.listCarrito);
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: <Widget>[
              viewResult,
              viewSearch,
              loading ? viewLoading : SizedBox(),
              empty ? viewEmpty : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
