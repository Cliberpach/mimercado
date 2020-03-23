class Package{
    int    id = 0;
    String name = '';
    String description = '';
    double price = 0.0;
    String pic_small = '';
    String pic_large = '';

    toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'pic_small': pic_small,
        'pic_large': pic_large,
    };
}