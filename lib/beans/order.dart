class Order {
  int method = null;
  String key = "";
  double priceTotal = null;
  double costShipping = null;
  String deliveryDate = null;
  String deliveryTime = null;
  int distance = null;
  int duration = null;
  int address = null;
  var items = [];

  toJson() => {
        'method': method,
        'key': key,
        'priceTotal': priceTotal,
        'costShipping': costShipping,
        'deliveryDate': deliveryDate,
        'deliveryTime': deliveryTime,
        'address': address,
        'items': items
      };
}
