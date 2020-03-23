class Stg{
  String url_api = "";
  String url_web = "";
  String address = "";
  String brand = "";
  String coin = "";
  String coin_name = "";
  String coin_short = "";
  String cost_shipping = "";
  String cost_shipping_km = "";
  String culqi_pk_private = "";
  String culqi_pk_public = "";
  String description = "";
  String email = "";
  String key_firebase = "";
  String key_maps = "";
  String lat = "";
  String lng = "";
  String name = "";
  String phone = "";

  toJson() => {
    "url_api": url_api,
    "url_web": url_web,
    "address": address,
    "brand": brand,
    "coin": coin,
    "coin_name": coin_name,
    "coin_short": coin_short,
    "cost_shipping": cost_shipping,
    "cost_shipping_km": cost_shipping_km,
    "culqi_pk_private": culqi_pk_private,
    "culqi_pk_public": culqi_pk_public,
    "description": description,
    "email": email,
    "key_firebase": key_firebase,
    "key_maps": key_maps,
    "lat": lat,
    "lng": lng,
    "name": name,
    "phone": phone
  };
}
