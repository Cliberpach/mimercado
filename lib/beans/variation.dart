import 'package:anvic/beans/pic.dart';

class Variation {
  int id = 0;
  String name = '';
  String description = '';
  Pic pic = null;
  int required = 0;
  int apply = 0;
  List<Variation> items = [];
  String apply_name = '';
  Variation select = null;

  Map<String, dynamic> toJson() => _itemToJson(this);

  Map<String, dynamic> _itemToJson(Variation instance) {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'apply': apply,
      'apply_name': apply_name,
      'select': selectToJson()
    };
  }

  selectToJson() {
    if (select != null) {
      return select.toJson();
    } else {
      return null;
    }
  }
}
