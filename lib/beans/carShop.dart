import '../beans/product.dart';
import '../beans/package.dart';
class CarShop{    
    final String  type;
    final int     id;
    final int     quantity;
    final double  price;
    final Product product;
    final Package package;
    
    CarShop(this.type,this.id,this.quantity,this.price,this.product,this.package);
}