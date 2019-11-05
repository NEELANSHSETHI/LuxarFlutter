import 'dart:async';
import 'dart:async' as prefix0;
import 'dart:convert';
import 'package:flutter_login_page_ui/models/cart_model.dart';
import 'package:flutter_login_page_ui/models/login_model.dart';
import 'package:flutter_login_page_ui/models/signup_model.dart';
import 'package:flutter_login_page_ui/models/status_model.dart';
import 'package:flutter_login_page_ui/models/upload_images.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

String token = '';
String HOST_URL = '';
SharedPreferences prefs;

Future<String> preferences() async {
  prefs = await SharedPreferences.getInstance();
  HOST_URL = 'http://192.168.31.54:5000/';
  token = prefs.getString('token');
  return HOST_URL;
}

Future<LoginModel> loginApi({String email, String password}) async {
  String api;
  await preferences().then((onValue) {
    api = onValue;
  });
  String endpoint = 'api/auth/login';
  String url = "$api$endpoint";
  print(url);
  final response = await http.post(url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({
        "email": '$email',
        "password": '$password',
      }));
  print(response.statusCode.toString() + "login");

  var res = loginModelFromJson(response.body);

  if (res.success == true) {
    prefs.setString('token', res.data.token);
  }
  return res;
}

Future<SignUpModel> signUpApi(
    {String email, String password, int phone, String name}) async {
  String api;
  await preferences().then((onValue) {
    api = onValue;
  });
  String endpoint = 'api/auth/signup';
  String url = "$HOST_URL$endpoint";
  print(url);

  Map body = {
    "email": "$email",
    "password": "$password",
    "name": "$name",
    "phone": phone
  };

  final response = await http.post(url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode(body));
  print(response.statusCode.toString() + "signUp");
  var res = signUpModelFromJson(response.body);

  if (res.success == true) {
    prefs.setString('token', res.data.token);
  }
  return res;
}

Future<UploadImagesModel> uploadImagesApi(
    http.MultipartFile file1,
    http.MultipartFile file2,
    http.MultipartFile file3,
    var mimeTypeData) async {
  String api;
  await preferences().then((onValue) {
    api = onValue;
  });
  String endpoint = 'api/user/images';
  String url = "$HOST_URL$endpoint";

  final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(url));
  Map<String, String> headers = {"auth": "$token"};
  imageUploadRequest.fields['ext'] = mimeTypeData[1];
  imageUploadRequest.headers.addAll(headers);
  imageUploadRequest.files.add(file1);
  imageUploadRequest.files.add(file2);
  imageUploadRequest.files.add(file3);

  try {
    final streamedResponse = await imageUploadRequest.send();
    print(imageUploadRequest.fields[1]);

    final response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);
    if (response.statusCode != 200) {
      return null;
    }
    print(response.statusCode.toString() + "uploadImages");
    return uploadImagesModelFromJson(response.body);
  } catch (e) {
    print(e);
    return null;
  }
}

Future<CartModel> cartApi() async {
  String api;
  await preferences().then((onValue) {
    api = onValue;
  });
  String endpoint = 'api/user/cart';
  String url = "$HOST_URL$endpoint";
  print(url);
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'auth': '$token'
    },
  );
  print(response.statusCode.toString() + "cartModel");
  if (response.statusCode != 200){
    print(response.body);
    return null;
  }
  else {
    print(cartModelFromJson(response.body).toJson());
    return cartModelFromJson(response.body);
  }
}

Future<StatusModel> statusApi() async {
  preferences();
  String endpoint = 'api/user/status';
  String url = "$HOST_URL$endpoint";
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'auth': '$token'
    },
  );
  print(response.statusCode.toString() + "statusApi");
  if (response.statusCode != 200){
    print(response.body);
    return null;
  }
  else {
    print(statusModelFromJson(response.body).toJson());
    return statusModelFromJson(response.body);
  }
}
