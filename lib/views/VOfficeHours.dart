import 'package:anvic/widgets/global_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../util/util.dart';
import '../util/pref.dart';
import '../models/globalButtons.dart';
import '../models/globalAlerts.dart';
import '../models/globalTexts.dart';
import 'package:url_launcher/url_launcher.dart';

class VOfficeHours extends StatefulWidget {
  @override
  _VOfficeHoursState createState() => _VOfficeHoursState();
}

class _VOfficeHoursState extends State<VOfficeHours> {
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

  @override
  Widget build(BuildContext context) {
    final viewInformation = Column(
      children: <Widget>[
        GlobalText(
          height: MediaQuery.of(context).size.width - 100,
          width: MediaQuery.of(context).size.width - 100,
          margin: 0,
          imgAsset: 'assets/img/logo_png.png',
        ),
        ListTile(
          title: GlobalText(
            margin: 0,
            textTitle: "Hora de apertura",
            textFontWeight: FontWeight.w500,
          ),
          subtitle: GlobalText(
            margin: 0,
            textTitle: pref.stg_time_open.isNotEmpty
                ? DateFormat.jm().format(
                    DateTime.parse('0000-00-00 ${pref.stg_time_open}'),
                  )
                : "",
          ),
        ),
        ListTile(
          title: GlobalText(
            margin: 0,
            textTitle: "Hora de cierre",
            textFontWeight: FontWeight.w500,
          ),
          subtitle: GlobalText(
            margin: 0,
            textTitle: pref.stg_time_open.isNotEmpty
                ? DateFormat.jm().format(
                    DateTime.parse('0000-00-00 ${pref.stg_time_close}'),
                  )
                : "",
          ),
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
            title: Text("Horario de atención"),
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
