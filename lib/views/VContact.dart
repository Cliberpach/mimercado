import 'package:anvic/widgets/global_text.dart';
import 'package:flutter/material.dart';
import '../util/util.dart';
import '../util/pref.dart';
import '../models/globalButtons.dart';
import '../models/globalAlerts.dart';
import '../models/globalTexts.dart';
import 'package:url_launcher/url_launcher.dart';

class VContact extends StatefulWidget {
  final String action;

  const VContact({Key key, this.action}) : super(key: key);

  @override
  _VContactState createState() => _VContactState();
}

class _VContactState extends State<VContact> {
  GlobalButtons globalButtons = GlobalButtons();
  GlobalAlerts globalAlerts = GlobalAlerts();
  GlobalTexts globalTexts = GlobalTexts();
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
  }

  launcher({@required type, value, lat, lng}) async {
    String url;

    switch (type) {
      case "phone":
        url = 'tel:$value';
        break;
      case "url":
        url = '$value';
        break;
      case "map":
        url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
        break;
      case "email":
        url = 'mailto:$value';
        break;
    }

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInformation = Column(
      children: <Widget>[
        ListTile(
          leading: GlobalText(
            icon: Icon(Icons.phone),
          ),
          title: GlobalText(
            margin: 0,
            textTitle: "Teléfono",
            textFontWeight: FontWeight.w500,
          ),
          subtitle: GlobalText(
            margin: 0,
            textTitle: pref.stg_phone,
          ),
          onTap: () => launcher(type: "phone", value: pref.stg_phone),
        ),
        ListTile(
          leading: GlobalText(
            icon: Icon(Icons.mail),
          ),
          title: GlobalText(
            margin: 0,
            textTitle: "Correo electrónico",
            textFontWeight: FontWeight.w500,
          ),
          subtitle: GlobalText(
            margin: 0,
            textTitle: pref.stg_email,
          ),
          onTap: () => launcher(type: "email", value: pref.stg_email),
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
            textTitle: pref.stg_address,
          ),
          onTap: () =>
              launcher(type: "map", lat: pref.stg_lat, lng: pref.stg_lng),
        ),
      ],
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(util.primaryColor),
            title: Text("Contáctenos"),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: <Widget>[
              ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[viewInformation],
              ),
            ],
          )),
    );
  }
}
