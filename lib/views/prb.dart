import 'package:anvic/beans/pic.dart';
import 'package:anvic/beans/product.dart';
import 'package:anvic/util/Config.dart';
import 'package:anvic/widgets/global_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../util/util.dart';
import '../util/pref.dart';
import 'VGalleryProduct.dart';

class Prb extends StatefulWidget {
  final String action;

  const Prb({Key key, this.action}) : super(key: key);

  @override
  _PrbState createState() => _PrbState();
}

class _PrbState extends State<Prb> {
  final refresh = GlobalKey<RefreshIndicatorState>();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  Util util = Util();
  Pref pref = Pref();
  Product product = Product();

  int _current = 0;

  Future<Null> getProduct() async {
    try {
      final response =
          await http.post("${util.BASE_URL}/products/product", body: {
        "token": pref.client_token,
        "id": '112',
      });

      var rsp = json.decode(response.body);

      print(rsp);

      rsp["pics"].forEach((item) {
        product.pics.add(
          Pic(
            id: 0,
            pic_large: item["pic_large"],
            pic_small: item["pic_small"],
          ),
        );
      });
      setState(() {});
    } catch (e) {
      print("Error:: $e");
    }
  }

//  Future<Null> loadData() {
//    return getProduct().then((rsp) {
//      setState(() {});
//    });
//  }

  @override
  void initState() {
    super.initState();
    pref.init().then((value) {
      setState(() {
        pref = value;
      });
    });
//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      refresh.currentState.show();
//    });
    getProduct();
  }

  CarouselSlider instance;

  nextSlider() {
    instance.nextPage(
        duration: new Duration(milliseconds: 300), curve: Curves.linear);
  }

  prevSlider() {
    instance.previousPage(
        duration: new Duration(milliseconds: 300), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Center(
//        child: Text("Hola"),
//      ),
//    );

    instance = CarouselSlider(
      viewportFraction: 1.0,
      height: 250.0,
      autoPlay: false,
      autoPlayInterval: Duration(seconds: 10),
      onPageChanged: (i) {
        setState(() {
          _current = i;
        });
      },
      items: product.pics.map((pic) {
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
                  builder: (context) => VGalleryProduct(pics: product.pics),
                ),
              ),
            );
          },
        );
      }).toList(),
    );

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SizedBox(
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
                  background: Colors.white.withOpacity(0.1),
                  alignmentContent: Alignment.center,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white.withOpacity(0.5),
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
                  background: Colors.white.withOpacity(0.1),
                  alignmentContent: Alignment.center,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.5),
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
                  children: product.pics.map((item) {
                    var index = product.pics.indexOf(item);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
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
          ),
        ],
      ),
    );

//    return WillPopScope(
//      onWillPop: () {
//        Navigator.pop(context);
//      },
//      child: Scaffold(
//        key: scaffoldKey,
//        appBar: AppBar(
//          backgroundColor: Config.colorPrimary,
//          title: Text("Producto"),
//          leading: IconButton(
//            icon: Icon(
//              Icons.arrow_back,
//              color: Colors.white,
//            ),
//            onPressed: () {
//              Navigator.pop(context);
//            },
//          ),
//        ),
//        body: RefreshIndicator(
//            key: refresh,
//            onRefresh: loadData,
//            child: Stack(
//              children: <Widget>[
//                ListView(
//                  scrollDirection: Axis.vertical,
//                  children: <Widget>[
//                    CarouselSlider(
//                      items: [1, 2, 3, 4, 5].map((i) {
//                        return new Builder(
//                          builder: (BuildContext context) {
//                            return new Container(
//                                width: MediaQuery.of(context).size.width,
//                                margin:
//                                    new EdgeInsets.symmetric(horizontal: 5.0),
//                                decoration:
//                                    new BoxDecoration(color: Colors.amber),
//                                child: new Text(
//                                  'text $i',
//                                  style: new TextStyle(fontSize: 16.0),
//                                ));
//                          },
//                        );
//                      }).toList(),
//                      height: 400.0,
//                      autoPlay: false,
//                    )
//                  ],
//                ),
//              ],
//            )),
//      ),
//    );
  }
}
