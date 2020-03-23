import 'package:anvic/widgets/global_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../util/pref.dart';
import '../util/util.dart';
import '../widgets/modal.dart';
import 'package:share/share.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  Util _util = Util();
  Pref _pref = Pref();
  Modal _modal = Modal();

  String _avatar = "";

  getAvatar() async {
    if (_pref.client_name != "" && _pref.client_surname != "") {
      String l1, l2;
      l1 = _pref.client_name.substring(0, 1).toUpperCase();
      l2 = _pref.client_surname.substring(0, 1).toUpperCase();
      _avatar = "${l1}${l2}";
    }
  }

  Future _logOut() async {
    await clearPref();
    Navigator.pushNamed(context, "/");
  }

  clearPref() {
    print("Clear Preferences");
    _pref.client_name = '';
    _pref.client_surname = '';
    _pref.client_dni = '';
    _pref.client_email = '';
    _pref.client_phone = '';
    _pref.client_token = '';
    _pref.stg_url_api = '';
    _pref.stg_url_web = '';
    _pref.stg_address = '';
    _pref.stg_brand = '';
    _pref.stg_coin = '';
    _pref.stg_coin_name = '';
    _pref.stg_coin_short = '';
    _pref.stg_cost_shipping = '';
    _pref.stg_cost_shipping_km = '';
    _pref.stg_culqi_pk_private = '';
    _pref.stg_culqi_pk_public = '';
    _pref.stg_description = '';
    _pref.stg_email = '';
    _pref.stg_key_firebase = '';
    _pref.stg_key_maps = '';
    _pref.stg_lat = '';
    _pref.stg_lng = '';
    _pref.stg_name = '';
    _pref.stg_phone = '';
    _pref.commit();
  }

  @override
  void initState() {
    super.initState();
    _pref.init().then((value) {
      setState(() {
        _pref = value;
      });
    });
    getAvatar();
  }

  @override
  Widget build(BuildContext context) {
    final brand = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GlobalText(
          height: 110,
          width: 110,
          margin: 0,
          imgAsset: 'assets/img/logo_png.png',
        ),
      ],
    );

    final user = Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFdddddd),
                    borderRadius: BorderRadius.circular(80.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(
                    _avatar,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30.0,
                      color: Color(_util.colorTres),
                    ),
                  )),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 184.0,
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "${_pref.client_name} ${_pref.client_surname}",
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: true,
                        style: TextStyle(
                          color: Color(_util.colorTres),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                          child: Text(
                            _pref.client_email,
                            style: TextStyle(color: Color(_util.leadAccent)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final optionsUser = Container(
      child: Column(
        children: <Widget>[
          Ink(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.home, color: Color(_util.brownPrimary)),
              title: Text(
                "Inicio",
                style: TextStyle(color: Color(_util.brownPrimary)),
              ),
              onTap: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          Ink(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.history, color: Color(_util.brownPrimary)),
              title: Text(
                "Mis pedidos",
                style: TextStyle(color: Color(_util.brownPrimary)),
              ),
              onTap: () => Navigator.pushNamed(context, "/history"),
            ),
          ),
          Ink(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.map, color: Color(_util.brownPrimary)),
              title: Text(
                "Mis direcciones",
                style: TextStyle(color: Color(_util.brownPrimary)),
              ),
              onTap: () => Navigator.pushNamed(context, "/address"),
            ),
          ),
          Ink(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.person, color: Color(_util.brownPrimary)),
              title: Text(
                "Editar perfil",
                style: TextStyle(color: Color(_util.brownPrimary)),
              ),
              onTap: () => Navigator.pushNamed(context, "/profile"),
            ),
          ),
          Ink(
            color: Colors.white,
            child: ListTile(
              leading:
                  Icon(Icons.contact_phone, color: Color(_util.brownPrimary)),
              title: Text(
                "Contáctenos",
                style: TextStyle(color: Color(_util.brownPrimary)),
              ),
              onTap: () => Navigator.pushNamed(context, "/contact"),
            ),
          ),
          Ink(
            color: Colors.white,
            child: ListTile(
              leading:
              Icon(Icons.today, color: Color(_util.brownPrimary)),
              title: Text(
                "Horario de atención",
                style: TextStyle(color: Color(_util.brownPrimary)),
              ),
              onTap: () => Navigator.pushNamed(context, "/officeHours"),
            ),
          ),
          Ink(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.share, color: Color(_util.brownPrimary)),
              title: Text(
                "Compartir app",
                style: TextStyle(color: Color(_util.brownPrimary)),
              ),
              onTap: () {
                Share.share(
                    'Te invito a descargar la aplicación de ${_pref
                        .stg_brand} ${_util.URL_PLAY_STORE}');
              },
            ),
          ),
          Ink(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.power_settings_new,
                  color: Color(_util.brownPrimary)),
              title: Text(
                "Cerrar sesión",
                style: TextStyle(color: Color(_util.brownPrimary)),
              ),
              onTap: () =>
                  _modal.confirm(context, "Cerrar sesión", "", _logOut),
            ),
          ),
//          Ink(
//            color: Colors.white,
//            child: ListTile(
//              onTap: () => Navigator.pushNamed(context, "/prb"),
//            ),
//          ),
        ],
      ),
    );

    return SafeArea(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[brand, user, optionsUser],
      ),
    );
  }
}
