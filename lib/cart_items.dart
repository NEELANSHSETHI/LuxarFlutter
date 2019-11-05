import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_page_ui/api/api_services.dart';
import 'package:flutter_login_page_ui/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Timer timer;
  int ctr;
  bool isOnline;

  @override
  void initState() {
    super.initState();
    isOnline = false;
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkStatus());
    ctr = 0;
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
            ),
            ListTile(
              leading: Icon(Icons.settings_power),
              title: Text("Logout"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
          leading: Icon(Icons.shopping_cart),
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
                    List t = snapshot.data.data.cart;
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
                              subtitle:
                                  Text("ID: ${snapshot.data.data.cart[0].id}"),
                              title: Text(
                                  "Name: ${snapshot.data.data.cart[0].name}\nQuantity: ${snapshot.data.data.cart[0].quantity}${ctr++}"),
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
                child: Center(
                    child: Text(
                  "Go Online!!",
                  style: TextStyle(fontSize: 25),
                )),
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
    });
  }
}
