class Category{
    int    id = 0;
    String name = '';
    String pic_small = '';
    String pic_large = '';

    toJson() => {
        'id': id,
        'name': name,
        'pic_small': pic_small,
        'pic_large': pic_large,
    };
}