import 'package:anvic/beans/variation.dart';

class Carrito {
  String type = '';
  int id = 0;
  String name = '';
  int quantity = 0;
  double price = 0.0;
  String pic_selected = '';
  int indexPic = 0;
  String apply_name = '';
  String val_apply_name = '';
  List<Variation> variations = [];
  List<Carrito> extras = [];

  Map<String, dynamic> toJson() => _itemToJson(this);

  Map<String, dynamic> _itemToJson(Carrito instance) {
    return <String, dynamic>{
      'type': type,
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'pic_selected': pic_selected,
      'indexPic': indexPic,
      'apply_name': apply_name,
      'val_apply_name': val_apply_name,
      'variations': variations,
      'extras': extrasToJson(),
    };
  }

  extrasToJson() {
    var ex = [];

    extras.forEach((e) {
      ex.add(e.toJson());
    });

    return ex;
  }
}
