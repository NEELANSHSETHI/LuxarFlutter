import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormCard extends StatefulWidget {
  final bool isLogin;
  FormCard({this.isLogin = false});

  @override
  _FormCardState createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {

  @override
  void initState() {
    super.initState();

  }

  addUserData(String id,String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(id, data);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.isLogin?"Login":"SignUp",
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(45),
                    fontFamily: "Poppins-Bold",
                    letterSpacing: .6)),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            !widget.isLogin?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Name",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26))),
                TextField(
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (v) {
                    addUserData('name', v.trim());
                    FocusScope.of(context).nextFocus();
                  },
                  decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(30),
                ),
                Text("PhoneNumber",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(26))),
                TextField(
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (v) {
                    addUserData('phone', v.trim());
                    FocusScope.of(context).nextFocus();
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: "PhoneNumber",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                ),
              ],
            ):Container(),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Email",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextField(
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onSubmitted: (v) {
                addUserData('email', v.trim());
                FocusScope.of(context).nextFocus();
              },
              decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("PassWord",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            TextField(
              autofocus: true,
              textInputAction: TextInputAction.done,
              obscureText: true,
              onSubmitted: (v){
                addUserData('password', v);
              },
              decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(35),
            ),
          ],
        ),
      ),
    );
  }
}
