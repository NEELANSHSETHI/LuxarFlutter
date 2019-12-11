import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'models/cart_model.dart';

class Receipt extends StatefulWidget {
  final List t;

  Receipt(this.t);

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {

  int _price;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
//              color: Colors.blue,
              height: MediaQuery.of(context).size.height * 0.65,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemBuilder: (BuildContext context, int index) =>
                      new Container(
                    child: _itemTile(widget.t[index]),
                  ),
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(1, 1.1),
                  itemCount: widget.t.length,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
              ),
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),color: Colors.lightBlueAccent
              ),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total = ₹${getTotal()}',
                  style: TextStyle(fontSize: 22,color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemTile(Cart cart) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.grey.withOpacity(.15)),
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: 100,
                  child: Image.network(
                    cart.image,
                    fit: BoxFit.fill,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Name: ${cart.name}\nQuantity: ${cart.quantity}\nPrice: ${cart.price}",
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  int getTotal(){
    _price=0;
    for (Cart c in widget.t){
      _price += c.price*c.quantity;
    }
    return _price;
  }
}
