import 'package:anvic/beans/pic.dart';
class Product{
    int    id = 0;
    String name = '';
    String description = '';
    String apply_name = '';
    double price = 0.0;
    List<Pic> pics = [];
    List extras = [];
    List variations = [];

    toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'apply_name': apply_name,
        'price': price,
        'exras': extras,
        'variations': variations
    };
}