import 'package:flutter/material.dart';
import 'package:flutter_login_page_ui/api/api_services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widgets/FormCard.dart';
import 'click_pics.dart';
import 'inputIPv4.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Opacity(
                    opacity: .3,
                    child: Image.asset(
                      "assets/undraw1.png",
                    )),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset("assets/image_02.png")
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/logo.png",
                      width: ScreenUtil.getInstance().setWidth(110),
                      height: ScreenUtil.getInstance().setHeight(110),
                    ),
                    Text("EZ SHOP",
                        style: TextStyle(
                            fontFamily: "Poppins-Bold",
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: <Color>[
                                  Color(0xFF17ead9),
                                  Color(0xFF6078ea)
                                ],
                              ).createShader(
                                  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                            fontSize: ScreenUtil.getInstance().setSp(76),
                            letterSpacing: .6,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                FormCard(
                  isLogin: isLogin,
                ),
                SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                InkWell(
                  child: Container(
                    width: ScreenUtil.getInstance().setWidth(330),
                    height: ScreenUtil.getInstance().setHeight(100),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF6078ea).withOpacity(.3),
                              offset: Offset(0.0, 8.0),
                              blurRadius: 8.0)
                        ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          print(prefs.getString('name'));
                          print(prefs.getString('email'));
                          print(prefs.getString('phone'));
                          print(prefs.getString('password'));
                          print(prefs.getString('ip'));

                          if (prefs.getString('ip') == null) {
                            showDialog(
                              context: context,
                              builder: (_) => FunkyOverlay(),
                            ).then((onValue) {
                              setState(() {
//                                  ipText = prefs.getString('ip') ?? "IP Not Found";
                              });
                            });
                          } else {
                            if (!isLogin) {
                              signUpApi(
                                      email: prefs.getString('email'),
                                      name: prefs.getString('name'),
                                      password: prefs.getString('password'),
                                      phone:
                                          int.parse(prefs.getString('phone')))
                                  .then((onValue) {
                                if (onValue.success == true)
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ClickPictures()));
                                else
                                  print(onValue.message);
                              });
                            } else {
                              loginApi(
                                      email: prefs.getString('email'),
                                      password: prefs.getString('password'))
                                  .then((onValue) {
                                print(onValue.message);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ClickPictures()));
                              });
                            }
                          }
                        },
                        child: Center(
                          child: Text(!isLogin ? "SIGNUP" : "SIGNIN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins-Bold",
                                  fontSize: 18,
                                  letterSpacing: 1.0)),
                        ),
                      ),
                    ),
                  ),
                ),

//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      horizontalLine(),
//                      Text("Social Login",
//                          style: TextStyle(
//                              fontSize: 16.0, fontFamily: "Poppins-Medium")),
//                      horizontalLine()
//                    ],
//                  ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(60),
                ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      SocialIcon(
//                        colors: [
//                          Color(0xFF102397),
//                          Color(0xFF187adf),
//                          Color(0xFF00eaf8),
//                        ],
//                        iconData: CustomIcons.facebook,
//                        onPressed: () {},
//                      ),
//                      SocialIcon(
//                        colors: [
//                          Color(0xFFff4f38),
//                          Color(0xFFff355d),
//                        ],
//                        iconData: CustomIcons.googlePlus,
//                        onPressed: () {},
//                      ),
//                      SocialIcon(
//                        colors: [
//                          Color(0xFF17ead9),
//                          Color(0xFF6078ea),
//                        ],
//                        iconData: CustomIcons.twitter,
//                        onPressed: () {},
//                      ),
//                      SocialIcon(
//                        colors: [
//                          Color(0xFF00c6fb),
//                          Color(0xFF005bea),
//                        ],
//                        iconData: CustomIcons.linkedin,
//                        onPressed: () {},
//                      )
//                    ],
//                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      isLogin ? "New User? " : "Already have an account?",
                      style: TextStyle(fontFamily: "Poppins-Medium"),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(!isLogin ? " Login" : " SignUp",
                          style: TextStyle(
                              color: Color(0xFF5d74e3),
                              fontFamily: "Poppins-Bold")),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
