import 'package:flutter/material.dart';
import '../util/util.dart';
import '../beans/carrito.dart';

class AddProductModal extends StatefulWidget {
  final Function(Carrito) c_save;
  final Function() c_cancel;
  final Carrito carrito;

  AddProductModal(this.c_save,this.c_cancel,this.carrito);

  @override
  _AddProductModalState createState() => _AddProductModalState(this.c_save,this.c_cancel,this.carrito);
}

class _AddProductModalState extends State<AddProductModal> {

  final Function(Carrito) c_save;
  final Function() c_cancel;
  final Carrito carrito;

  _AddProductModalState(this.c_save,this.c_cancel,this.carrito);

  Util _util = Util();
  int _quantity = 1;
  var _ctApplyName = TextEditingController();

  void _increment(){
    if(carrito.price > 0){
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrement(){
    if(_quantity > 1){
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      if(carrito.quantity > 0){
        _quantity = carrito.quantity;
      }

      print(carrito.quantity);
      _ctApplyName.text = carrito.val_apply_name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){},
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 120,
                      child: Text(
                        "${carrito.name}",
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Icon(
                                Icons.clear,
                                color: Color(_util.rosado),
                              ),
                            ),
                            onTap: (){
                              c_cancel();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Icon(
                                Icons.check,
                                color: Color(_util.greenPrimary),
                              ),
                            ),
                            onTap: (){
                              carrito.quantity = _quantity;
                              c_save(carrito);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Material(
                          child: InkWell(
                            child: Container(
                              height: 50.0,
                              width: 50.0,
                              child: Center(
                                child: Icon(
                                    Icons.remove
                                ),
                              ),
                            ),
                            onTap: _decrement,
                          ),
                        ),
                        Material(
                          child: InkWell(
                            child: Container(
                              height: 50.0,
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Center(
                                  child: Text(
                                    "$_quantity",
                                    style: TextStyle(
                                        fontSize: 16.0
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),
                        Material(
                          child: InkWell(
                            child: Container(
                              height: 50.0,
                              width: 50.0,
                              child: Center(
                                child: Icon(
                                    Icons.add
                                ),
                              ),
                            ),
                            onTap: _increment,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Text(
                          "S/.${(_quantity*carrito.price).toStringAsFixed(2)}"
                      ),
                    )
                  ],
                ),
              ),
              carrito.apply_name != "" ? Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "${carrito.apply_name}",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Container(
                      color: Color(_util.colorTres),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextField(
                        controller: _ctApplyName,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Ingresar',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(_util.colorTres),width: 1.0),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(_util.colorTres), width: 1.0),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                        ),
                        style: TextStyle(
                            color: Color(_util.colorTres),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                        onChanged: (val){
                          carrito.val_apply_name = val;
                        },
                      ),
                    ),
                    Container(height: 20.0)
                  ],
                ),
              ) : SizedBox(),
            ],
          ),
        )
    );
  }
}

