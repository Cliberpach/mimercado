import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static const CLIENT_LAT = "client_lat";
  static const CLIENT_LNG = "client_lng";
  static const CLIENT_NAME = "client_name";
  static const CLIENT_SURNAME = "client_surname";
  static const CLIENT_DNI = "client_dni";
  static const CLIENT_EMAIL = "client_email";
  static const CLIENT_PHONE = "client_phone";
  static const CLIENT_TOKEN = "client_token";
  static const STG_URL_API = "stg_url_api";
  static const STG_URL_WEB = "stg_url_web";
  static const STG_ADDRESS = "stg_address";
  static const STG_BRAND = "stg_brand";
  static const STG_COIN = "stg_coin";
  static const STG_COIN_NAME = "stg_coin_name";
  static const STG_COIN_SHORT = "stg_coin_short";
  static const STG_COST_SHIPPING = "stg_cost_shipping";
  static const STG_COST_SHIPPING_KM = "stg_cost_shipping_km";
  static const MIN_SHIPPING_KM = "min_shipping_km";
  static const STG_CULQI_PK_PRIVATE = "stg_culqi_pk_private";
  static const STG_CULQI_PK_PUBLIC = "stg_culqi_pk_public";
  static const STG_DESCRIPTION = "stg_description";
  static const STG_EMAIL = "stg_email";
  static const STG_KEY_FIREBASE = "stg_key_firebase";
  static const STG_KEY_MAPS = "stg_key_maps";
  static const STG_LAT = "stg_lat";
  static const STG_LNG = "stg_lng";
  static const STG_NAME = "stg_name";
  static const STG_PHONE = "stg_phone";
  static const STG_TIME_OPEN = "stg_time_open";
  static const STG_TIME_CLOSE = "stg_time_close";

  static final Pref instance = Pref._internal();
  SharedPreferences _sharedPreferences;

  String client_lat = '';
  String client_lng = '';
  String client_name = '';
  String client_surname = '';
  String client_dni = '';
  String client_email = '';
  String client_phone = '';
  String client_token = '';
  String stg_url_api = '';
  String stg_url_web = '';
  String stg_address = '';
  String stg_brand = '';
  String stg_coin = '';
  String stg_coin_name = '';
  String stg_coin_short = '';
  String stg_cost_shipping = '';
  String stg_cost_shipping_km = '';
  String stg_min_shipping_km = '';
  String stg_culqi_pk_private = '';
  String stg_culqi_pk_public = '';
  String stg_description = '';
  String stg_email = '';
  String stg_key_firebase = '';
  String stg_key_maps = '';
  String stg_lat = '';
  String stg_lng = '';
  String stg_name = '';
  String stg_phone = '';
  String stg_time_open = '';
  String stg_time_close = '';

  Pref._internal() {}

  factory Pref() => instance;

  Future<SharedPreferences> get preferences async {
    if (_sharedPreferences != null) {
      return _sharedPreferences;
    } else {
      _sharedPreferences = await SharedPreferences.getInstance();

      client_lat = _sharedPreferences.getString(CLIENT_LAT);
      client_lng = _sharedPreferences.getString(CLIENT_LNG);
      client_name = _sharedPreferences.getString(CLIENT_NAME);
      client_surname = _sharedPreferences.getString(CLIENT_SURNAME);
      client_dni = _sharedPreferences.getString(CLIENT_DNI);
      client_email = _sharedPreferences.getString(CLIENT_EMAIL);
      client_phone = _sharedPreferences.getString(CLIENT_PHONE);
      client_token = _sharedPreferences.getString(CLIENT_TOKEN);
      stg_url_api = _sharedPreferences.getString(STG_URL_API);
      stg_url_web = _sharedPreferences.getString(STG_URL_WEB);
      stg_address = _sharedPreferences.getString(STG_ADDRESS);
      stg_brand = _sharedPreferences.getString(STG_BRAND);
      stg_coin = _sharedPreferences.getString(STG_COIN);
      stg_coin_name = _sharedPreferences.getString(STG_COIN_NAME);
      stg_coin_short = _sharedPreferences.getString(STG_COIN_SHORT);
      stg_cost_shipping = _sharedPreferences.getString(STG_COST_SHIPPING);
      stg_cost_shipping_km = _sharedPreferences.getString(STG_COST_SHIPPING_KM);
      stg_min_shipping_km = _sharedPreferences.getString(MIN_SHIPPING_KM);
      stg_culqi_pk_private = _sharedPreferences.getString(STG_CULQI_PK_PRIVATE);
      stg_culqi_pk_public = _sharedPreferences.getString(STG_CULQI_PK_PUBLIC);
      stg_description = _sharedPreferences.getString(STG_DESCRIPTION);
      stg_email = _sharedPreferences.getString(STG_EMAIL);
      stg_key_firebase = _sharedPreferences.getString(STG_KEY_FIREBASE);
      stg_key_maps = _sharedPreferences.getString(STG_KEY_MAPS);
      stg_lat = _sharedPreferences.getString(STG_LAT);
      stg_lng = _sharedPreferences.getString(STG_LNG);
      stg_name = _sharedPreferences.getString(STG_NAME);
      stg_phone = _sharedPreferences.getString(STG_PHONE);
      stg_time_open = _sharedPreferences.getString(STG_TIME_OPEN);
      stg_time_close = _sharedPreferences.getString(STG_TIME_CLOSE);

      if (client_token == null) {
        client_lat = '';
        client_lng = '';
        client_name = '';
        client_surname = '';
        client_dni = '';
        client_email = '';
        client_phone = '';
        client_token = '';
        stg_url_api = '';
        stg_url_web = '';
        stg_address = '';
        stg_brand = '';
        stg_coin = '';
        stg_coin_name = '';
        stg_coin_short = '';
        stg_cost_shipping = '';
        stg_cost_shipping_km = '';
        stg_min_shipping_km = '';
        stg_culqi_pk_private = '';
        stg_culqi_pk_public = '';
        stg_description = '';
        stg_email = '';
        stg_key_firebase = '';
        stg_key_maps = '';
        stg_lat = '';
        stg_lng = '';
        stg_name = '';
        stg_phone = '';
        stg_time_open = '';
        stg_time_close = '';
      }

      return _sharedPreferences;
    }
  }

  Future<bool> commit() async {
    /*clave - valor*/
    await _sharedPreferences.setString(CLIENT_LAT, client_lat);
    await _sharedPreferences.setString(CLIENT_LNG, client_lng);
    await _sharedPreferences.setString(CLIENT_NAME, client_name);
    await _sharedPreferences.setString(CLIENT_SURNAME, client_surname);
    await _sharedPreferences.setString(CLIENT_DNI, client_dni);
    await _sharedPreferences.setString(CLIENT_EMAIL, client_email);
    await _sharedPreferences.setString(CLIENT_PHONE, client_phone);
    await _sharedPreferences.setString(CLIENT_TOKEN, client_token);
    await _sharedPreferences.setString(STG_URL_API, stg_url_api);
    await _sharedPreferences.setString(STG_URL_WEB, stg_url_web);
    await _sharedPreferences.setString(STG_ADDRESS, stg_address);
    await _sharedPreferences.setString(STG_BRAND, stg_brand);
    await _sharedPreferences.setString(STG_COIN, stg_coin);
    await _sharedPreferences.setString(STG_COIN_NAME, stg_coin_name);
    await _sharedPreferences.setString(STG_COIN_SHORT, stg_coin_short);
    await _sharedPreferences.setString(STG_COST_SHIPPING, stg_cost_shipping);
    await _sharedPreferences.setString(STG_COST_SHIPPING_KM, stg_cost_shipping_km);
    await _sharedPreferences.setString(MIN_SHIPPING_KM, stg_min_shipping_km);
    await _sharedPreferences.setString(STG_CULQI_PK_PRIVATE, stg_culqi_pk_private);
    await _sharedPreferences.setString(STG_CULQI_PK_PUBLIC, stg_culqi_pk_public);
    await _sharedPreferences.setString(STG_DESCRIPTION, stg_description);
    await _sharedPreferences.setString(STG_EMAIL, stg_email);
    await _sharedPreferences.setString(STG_KEY_FIREBASE, stg_key_firebase);
    await _sharedPreferences.setString(STG_KEY_MAPS, stg_key_maps);
    await _sharedPreferences.setString(STG_LAT, stg_lat);
    await _sharedPreferences.setString(STG_LNG, stg_lng);
    await _sharedPreferences.setString(STG_NAME, stg_name);
    await _sharedPreferences.setString(STG_PHONE, stg_phone);
    await _sharedPreferences.setString(STG_TIME_OPEN, stg_time_open);
    await _sharedPreferences.setString(STG_TIME_CLOSE, stg_time_close);
  }

  Future<Pref> init() async {
    _sharedPreferences = await preferences;
    return this;
  }
}
