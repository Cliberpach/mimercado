import 'package:anvic/util/Config.dart';
import 'package:flutter/material.dart';
import '../util/util.dart';
import '../util/pref.dart';
import '../models/globalButtons.dart';
import '../models/globalAlerts.dart';
import '../widgets/global_text.dart';
import '../beans/variation.dart';
import 'VGalleryProduct.dart';

class VSelectVariation extends StatefulWidget {
  final Variation variation;

  const VSelectVariation({Key key, this.variation}) : super(key: key);

  @override
  _VSelectVariationState createState() => _VSelectVariationState();
}

class _VSelectVariationState extends State<VSelectVariation> {
  GlobalButtons globalButtons = GlobalButtons();
  GlobalAlerts globalAlerts = GlobalAlerts();
  Util util = Util();
  Pref pref = Pref();

  List<Variation> items = List();
  List<Widget> itemsList = List();

  fillItems() {
    itemsList = [];
    widget.variation.items.forEach((item) {
      bool exist = false;

      if ((widget.variation.select != null) &&
          item.id == widget.variation.select.id) {
        exist = true;
      }

      itemsList.add(
        Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(10.0),
              leading: InkWell(
                child: Container(
                  height: 60.0,
                  width: 60.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: 'assets/img/kake.png',
                      image: item.pic.pic_small,
                    ),
                  ),
                ),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VGalleryProduct(pics: [], pic: item.pic),
                      ),
                    ),
              ),
              title: GlobalText(
                marginTop: 0,
                textTitle: item.name,
                textColor: Config.colorTextBold,
              ),
              trailing: exist
                  ? Container(
                      width: 25.0,
                      height: 25.0,
                      child: Icon(
                        Icons.check_box,
                        color: Color(util.greenPrimary),
                        size: 25.0,
                      ),
                    )
                  : Container(
                      width: 25.0,
                      height: 25.0,
                      child: Icon(
                        Icons.check_box_outline_blank,
                        color: Color(util.texto),
                        size: 25.0,
                      ),
                    ),
              onTap: () => selectItem(item),
            ),
            Divider(height: 0.0),
          ],
        ),
      );

//      itemsList.add(
//        Container(
//          padding: EdgeInsets.only(top: 10.0),
//          child: ListTile(
//            leading:

//            InkWell(
//              child: Container(
//                height: 60.0,
//                width: 60.0,
//                child: ClipRRect(
//                  borderRadius: BorderRadius.circular(10),
//                  child: FadeInImage(
//                    placeholder: AssetImage("assets/img/kake.png"),
//                    image: NetworkImage(item.pic.pic_small),
//                    fit: BoxFit.cover,
//                  ),
//                ),
//              ),

//              onTap: () => Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) =>
//                            VGalleryProduct(pics: [], pic: item.pic)),
//                  ),
//            ),
//            title: Row(
//              children: <Widget>[
//                Expanded(
//                  child: globalTexts.textOne(
//                      title: "${item.name}",
//                      textColor: util.colorSix,
//                      padding: 0.0,
//                      fontFamily: "GeoBook"),
//                ),
//              ],
//            ),
//            trailing: exist
//                ? Container(
//                    width: 25.0,
//                    height: 25.0,
//                    child: Icon(
//                      Icons.check_box,
//                      color: Color(util.greenPrimary),
//                      size: 25.0,
//                    ),
//                  )
//                : Container(
//                    width: 25.0,
//                    height: 25.0,
//                    child: Icon(
//                      Icons.check_box_outline_blank,
//                      color: Color(util.texto),
//                      size: 25.0,
//                    ),
//                  ),
//            onTap: () => selectItem(item),
//          ),
//        ),
//      );
    });
  }

  selectItem(Variation item) {
    if (widget.variation.required == 1) {
      widget.variation.select = item;
      Navigator.pop(context, widget.variation);
    } else {
      if (widget.variation.select == null) {
        setState(() {
          widget.variation.select = item;
        });
      } else {
        if (item.id == widget.variation.select.id) {
          setState(() {
            widget.variation.select = null;
          });
        } else {
          setState(() {
            widget.variation.select = item;
          });
        }
      }
      fillItems();
    }
  }

  @override
  void initState() {
    super.initState();
    pref.init().then((value) {
      setState(() {
        pref = value;
      });
    });

    fillItems();
  }

  @override
  Widget build(BuildContext context) {
    final viewItems = Column(children: itemsList);

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, widget.variation);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(util.primaryColor),
          title: Text(widget.variation.name),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, widget.variation);
            },
          ),
        ),
        body: Stack(children: <Widget>[
          ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[viewItems, SizedBox(height: 60.0)],
          ),
        ]),
      ),
    );
  }
}
