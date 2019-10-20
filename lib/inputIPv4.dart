import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  TextEditingController textEditingController;
  SharedPreferences prefs;
  String initialValue;

  @override
  initState() {
    super.initState();
    preferences();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    textEditingController = new TextEditingController();

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      offset: Offset(0.0, 8.0),
                      blurRadius: 8.0)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Enter the IPv4 Address",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Poppins-Bold",
                          fontSize: 18,
                          letterSpacing: 1.0)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                      ),
                      onFieldSubmitted: (v) {
                        prefs.setString('ip', v);
                        Navigator.pop(context);
                        print(prefs.getString('ip'));
                        setState(() {});
                      },
                      maxLength: 15,
                      maxLines: 1,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  preferences() async {
    prefs = await SharedPreferences.getInstance();
  }
}
