import 'pref.dart';

class Util {
//  final String BASE_URL = "http://beta.wabir.com/anvic/api/client";
//  final String BASE_URL_PIC = "http://beta.wabir.com/anvic/api/uploads/";
//util.BASE_URL
  final String BASE_URL = "http://democlientes.tortasanvic.com/admin/api/client";
  final String BASE_URL_PIC = "http://democlientes.tortasanvic.com/admin/api/uploads/";
  final String TERMS_URL = "http://google.com";
  final String URL_PLAY_STORE = "https://play.google.com/store/apps/details?id=com.trujilloapps.mimercado";

  final String BRAND = "Mi Mercado";

  final int bluePrimary = 0xFF3AEFF7; //celeste tono claro
  final int pinkPrimary = 0xFFF19BC1; //Rosado
  final int brownPrimary = 0xFF322626; //Marron
  final int leadPrimary = 0xFF260B36; //Plomo
  final int whitePrimary = 0xFFFFFFFF; //Plomo
  final int blackPrimary = 0xFF43484C; //Negro
  final int greenPrimary = 0xFF25C48A; //Verde
  final int brownAccent = 0xFF57381F; //Marron
  final int leadAccent = 0xFF9F9F9D; //Plomo
  final int yellowAccent = 0xFFFFE793; //Amarillo
  final int greenAccent = 0xFF00CED3; //Verde
  final int blackAccent = 0xFF808185; //Negro

  final int rosado = 0xFFFA0055; //rosado
  final int texto = 0XFF888888; //color texto
  final int shadow = 0XFF494949; //color sombra
  final int ambar = 0xFFF79900; //color amarillo

  final int primaryColor = 0xFFFA05B3;
  final int accentColor = 0xFFD20097;
  final int colorUno = 0xFFAAEAF3;
  final int colorDos = 0xFF71D8E5;
  final int colorTres = 0xFF625C77;
  final int colorFor = 0xFFDFDFDF;
  final int colorFive = 0xFF99C6F6;
  final int colorSix = 0xFF253239;
  final int colorSeven = 0xFFF9F9F9;

  //===============================================//

  Pref pref = Pref();

  printPreferences() {
    print("Util print preferences from util");
    print("client_lat ${pref.client_lat}");
    print("client_lng ${pref.client_lng}");
    print("client_name ${pref.client_name}");
    print("client_surname ${pref.client_surname}");
    print("client_dni ${pref.client_dni}");
    print("client_email ${pref.client_email}");
    print("client_phone ${pref.client_phone}");
    print("client_token ${pref.client_token}");
    print("stg_url_api ${pref.stg_url_api}");
    print("stg_url_web ${pref.stg_url_web}");
    print("stg_address ${pref.stg_address}");
    print("stg_brand ${pref.stg_brand}");
    print("stg_coin ${pref.stg_coin}");
    print("stg_coin_name ${pref.stg_coin_name}");
    print("stg_coin_short ${pref.stg_coin_short}");
    print("stg_cost_shipping ${pref.stg_cost_shipping}");
    print("stg_cost_shipping_km ${pref.stg_cost_shipping_km}");
    print("stg_culqi_pk_private ${pref.stg_culqi_pk_private}");
    print("stg_culqi_pk_public ${pref.stg_culqi_pk_public}");
    print("stg_description ${pref.stg_description}");
    print("stg_email ${pref.stg_email}");
    print("stg_key_firebase ${pref.stg_key_firebase}");
    print("stg_key_maps ${pref.stg_key_maps}");
    print("stg_lat ${pref.stg_lat}");
    print("stg_lng ${pref.stg_lng}");
    print("stg_name ${pref.stg_name}");
    print("stg_phone ${pref.stg_phone}");
  }

  savePreferences(var rspClient, var rspStg) {
    pref.client_name = rspClient["name"];
    pref.client_surname = rspClient["surname"];
    pref.client_dni = rspClient["dni"];
    pref.client_email = rspClient["email"];
    pref.client_phone = rspClient["phone"];
    pref.client_token = rspClient["token"];
    pref.stg_url_api = rspStg["url_api"];
    pref.stg_url_web = rspStg["url_web"];
    pref.stg_address = rspStg["address"];
    pref.stg_brand = rspStg["brand"];
    pref.stg_coin = rspStg["coin"];
    pref.stg_coin_name = rspStg["coin_name"];
    pref.stg_coin_short = rspStg["coin_short"];
    pref.stg_cost_shipping = rspStg["cost_shipping"];
    pref.stg_cost_shipping_km = rspStg["cost_shipping_km"];
    pref.stg_min_shipping_km = rspStg["min_shipping_km"];
    pref.stg_culqi_pk_private = rspStg["culqi_pk_private"];
    pref.stg_culqi_pk_public = rspStg["culqi_pk_public"];
    pref.stg_description = rspStg["description"];
    pref.stg_email = rspStg["email"];
    pref.stg_key_firebase = rspStg["key_firebase"];
    pref.stg_key_maps = rspStg["key_maps"];
    pref.stg_lat = rspStg["lat"];
    pref.stg_lng = rspStg["lng"];
    pref.stg_name = rspStg["name"];
    pref.stg_phone = rspStg["phone"];
    pref.stg_time_open = rspStg["time_open"];
    pref.stg_time_close = rspStg["time_close"];
    pref.commit();
  }

  clearPref() {
    print("Clear Preferences");
    pref.client_name = '';
    pref.client_surname = '';
    pref.client_dni = '';
    pref.client_email = '';
    pref.client_phone = '';
    pref.client_token = '';
    pref.stg_url_api = '';
    pref.stg_url_web = '';
    pref.stg_address = '';
    pref.stg_brand = '';
    pref.stg_coin = '';
    pref.stg_coin_name = '';
    pref.stg_coin_short = '';
    pref.stg_cost_shipping = '';
    pref.stg_cost_shipping_km = '';
    pref.stg_culqi_pk_private = '';
    pref.stg_culqi_pk_public = '';
    pref.stg_description = '';
    pref.stg_email = '';
    pref.stg_key_firebase = '';
    pref.stg_key_maps = '';
    pref.stg_lat = '';
    pref.stg_lng = '';
    pref.stg_name = '';
    pref.stg_phone = '';
    pref.commit();
  }
}
