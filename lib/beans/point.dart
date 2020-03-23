import 'package:google_maps_flutter/google_maps_flutter.dart';

class Point {
  int id;
  double lat;
  double lng;
  String address = '';

  Point(this.lat, this.lng, {this.id = 0, this.address = ''});

  LatLng toLatLng() {
    return LatLng(lat, lng);
  }
}
