import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_page_ui/api/api_services.dart';
import 'package:flutter_login_page_ui/main.dart';
import 'package:flutter_login_page_ui/receipt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Timer timer;
  int ctr;
  bool isOnline;
  List t;

  @override
  void initState() {
    super.initState();
    isOnline = false;
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkStatus());
    ctr = 0;
    t = new List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        child: Icon(Icons.person),
                        radius: 30,
                        backgroundColor: Colors.white,
                      ),
                      Text(
                        '${prefs.getString('name')}',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        '${prefs.getString('email')}',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                )),
            ListTile(
              leading: Icon(Icons.settings_power),
              title: Text("Logout"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pop(context);
                timer.cancel();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
          leading: Builder(builder: (context) => IconButton(icon: Icon(Icons.shopping_cart),onPressed: () => Scaffold.of(context).openDrawer(),)),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(isOnline ? "Status: Online" : "Status: Offline")),
            )
          ],
          title: Text(
            "Cart Items",
          )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: isOnline
            ? FutureBuilder(
                future: cartApi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) if (snapshot.data.success == true) {
                    t = snapshot.data.data.cart;
                    if (t.length == 0)
                      return Image.asset(
                        'assets/cart_is_empty.png',
                        scale: 1.5,
                        color: Colors.redAccent,
                      );
                    return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        color: Colors.white,
                        height: 2,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: ListTile(
                              leading: Image.network(
                                  snapshot.data.data.cart[index].image),
                              dense: true,
                              subtitle: Text(
                                  "ID: ${snapshot.data.data.cart[index].id}"),
                              title: Text(
                                  "Name: ${snapshot.data.data.cart[index].name}\nQuantity: ${snapshot.data.data.cart[index].quantity}\nPrice: ${snapshot.data.data.cart[index].price}"),
                            ),
                          ),
                        );
                      },
                      itemCount: t.length,
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                },
              )
            : Container(
                child: t.isEmpty
                    ? Center(
                        child: Text(
                        "Go Online!!",
                        style: TextStyle(fontSize: 25),
                      ))
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Thanks for Shopping!",
                              style: TextStyle(fontSize: 25),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Receipt(t))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.receipt,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'View Receipt',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
//                                  side: BorderSide(color: Colors.red)
                              ),
                              color: Colors.lightBlueAccent,
                            )
                          ],
                        ),
                      ),
              ),
      ),
    );
  }

  checkStatus() {
    statusApi().then((onValue) {
      if (onValue != null && onValue.success == true) if (onValue.data.status ==
          'ONLINE')
        setState(() {
          isOnline = true;
        });
      if (onValue.data.status == 'OFFLINE')
        setState(() {
          isOnline = false;
        });
    });
  }
}
