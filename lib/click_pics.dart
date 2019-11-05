import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'inputIPv4.dart';
import 'api/api_services.dart';

class ClickPictures extends StatefulWidget {
  @override
  _ClickPicturesState createState() => _ClickPicturesState();
}

class _ClickPicturesState extends State<ClickPictures> {
  Future<File> file1;
  Future<File> file2;
  Future<File> file3;
  String status = '';
  String base64Image;
  File image1;
  File image2;
  File image3;
  String errMessage = 'Error Uploading Image';
  bool _isUploading = false;
  SharedPreferences prefs;
  String ipText;
  String uploadText;

  @override
  void initState() {
      super.initState();
      uploadText = "Upload";
      preferences();
  }

  Widget _pictureBox(VoidCallback onPressed, int i) => Column(
        children: <Widget>[
          InkWell(
            onTap: onPressed,
            child: Container(
              height: MediaQuery.of(context).size.width * 0.25,
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF6078ea).withOpacity(.1),
                        offset: Offset(0.0, 8.0),
                        blurRadius: 8.0)
                  ]),
//              child: Icon(
//                Icons.camera_alt,
//                color: Colors.red.withOpacity(.3),
//              ),
              child: showImage(i),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
        body: Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _pictureBox(() {
                  chooseImage(1);
                }, 1),
                _pictureBox(() {
                  chooseImage(2);
                }, 2),
                _pictureBox(() {
                  chooseImage(3);
                }, 3),
              ],
            ),
          ),
          button(),

        ],
      ),
    ));
  }

  Widget button () {
    if (_isUploading) {
      // File is being uploaded then show a progress indicator
      return Container(
          margin: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator());
    } else
      return Column(
        children: <Widget>[
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
                  onTap: () {

                    if(prefs.getString('ip')==null) {
                      showDialog(
                        context: context,
                        builder: (_) => FunkyOverlay(),
                      ).then((onValue) {
                        setState(() {
                          ipText = prefs.getString('ip') ?? "IP Not Found";
                        });
                      });
                    }
                    else{
                      _uploadImage();
                    }

                  },
                  child: Center(
                    child: Text(uploadText,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Sending request to $ipText",style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                letterSpacing: 1.0),),
          )
        ],
      );
  }

  preferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      ipText = prefs.getString('ip')?? "IP Not Found";
    });
  }

  chooseImage(int i) {
    setState(() {
      if (i == 1)
        file1 = ImagePicker.pickImage(source: ImageSource.camera);
      else if (i == 2)
        file2 = ImagePicker.pickImage(source: ImageSource.camera);
      else if (i == 3)
        file3 = ImagePicker.pickImage(source: ImageSource.camera);
    });
  }

  Widget showImage(int i) {
    if (i == 1)
      return FutureBuilder<File>(
        future: file1,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            image1 = snapshot.data;
            base64Image = base64Encode(snapshot.data.readAsBytesSync());
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(
                    snapshot.data,
                    fit: BoxFit.fitWidth,
                  ),
                  Container(
                    color: Colors.grey.withOpacity(.5),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 48,
                    ),
                  )
                ],
              ),
            );
          } else if (null != snapshot.error) {
            return const Text(
              'Error Picking Image',
              textAlign: TextAlign.center,
            );
          } else {
            if (image1 != null)
              return Image.file(
                image1,
                fit: BoxFit.fill,
              );
            else
              return Opacity(opacity: .5, child: const Icon(Icons.camera_alt));
          }
        },
      );
    else if (i == 2)
      return FutureBuilder<File>(
        future: file2,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            image2 = snapshot.data;
            base64Image = base64Encode(snapshot.data.readAsBytesSync());
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(
                    snapshot.data,
                    fit: BoxFit.fitWidth,
                  ),
                  Container(
                    color: Colors.grey.withOpacity(.5),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 48,
                    ),
                  )
                ],
              ),
            );
          } else if (null != snapshot.error) {
            return const Text(
              'Error Picking Image',
              textAlign: TextAlign.center,
            );
          } else {
            if (image2 != null)
              return Image.file(
                image2,
                fit: BoxFit.fill,
              );
            else
              return Opacity(opacity: .5, child: const Icon(Icons.camera_alt));
          }
        },
      );
    else if (i == 3)
      return FutureBuilder<File>(
        future: file3,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            image3 = snapshot.data;
            base64Image = base64Encode(snapshot.data.readAsBytesSync());
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(
                    snapshot.data,
                    fit: BoxFit.fitWidth,
                  ),
                  Container(
                    color: Colors.grey.withOpacity(.5),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 48,
                    ),
                  )
                ],
              ),
            );
          } else if (null != snapshot.error) {
            return const Text(
              'Error Picking Image',
              textAlign: TextAlign.center,
            );
          } else {
            if (image3 != null)
              return Image.file(
                image3,
                fit: BoxFit.fill,
              );
            else
              return Opacity(opacity: .5, child: const Icon(Icons.camera_alt));
          }
        },
      );
    else
      return Container();
  }

   _uploadImage() async {
    setState(() {
      _isUploading = true;
    });

    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
        lookupMimeType(image1.path, headerBytes: [0xFF, 0xD8]).split('/');

    print("imahepath ${image1.path}");
    final file1 = await http.MultipartFile.fromPath('front', image1.path,filename: "front.${mimeTypeData[1]}",
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    final file2 = await http.MultipartFile.fromPath('left', image2.path,filename: "left.${mimeTypeData[1]}",
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    final file3 = await http.MultipartFile.fromPath('right', image3.path,filename: "right.${mimeTypeData[1]}",
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension
    uploadImagesApi(file1,file2,file3,mimeTypeData).then((onValue){

      if (onValue == null || onValue.success==false) {
        _resetState();
        Toast.show("Image Upload Failed!!!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
          setState(() {
            _isUploading = false;
            uploadText = "Uploaded";
          });
        Toast.show("Image Uploaded Successfully!!!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    });

  }

//  Future findBaseUrl() async {
//
//    NetworkInterface.list(includeLoopback: false, type: InternetAddressType.IPv4)
//        .then((List<NetworkInterface> interfaces) {
//      setState( () {
//        _networkInterface = "";
//        interfaces.forEach((interface) {
//          _networkInterface += "### name: ${interface.name}\n";
//          int i = 0;
//          interface.addresses.forEach((address) {
//            _networkInterface += "${i++}) ${address.address}\n";
//          });
//        });
//      });
//    });
//
//    print("IPIPIPIP $_networkInterface");
//
//    for (var interface in await NetworkInterface.list(type: InternetAddressType.IPv6,includeLinkLocal: false)) {
//    print('== Interface: ${interface.name} ==');
//    for (var addr in interface.addresses) {
//    print(
//    '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
//    }
//    }
//  }

  void _resetState() {
    setState(() {
      _isUploading = false;
      uploadText = "Upload";
      file1 = null;
      file2 = null;
      file3 = null;
    });
  }
}
