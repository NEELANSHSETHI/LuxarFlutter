// To parse this JSON data, do
//
//     final uploadImagesModel = uploadImagesModelFromJson(jsonString);

import 'dart:convert';

UploadImagesModel uploadImagesModelFromJson(String str) => UploadImagesModel.fromJson(json.decode(str));

String uploadImagesModelToJson(UploadImagesModel data) => json.encode(data.toJson());

class UploadImagesModel {
  bool success;
  String message;

  UploadImagesModel({
    this.success,
    this.message,
  });

  factory UploadImagesModel.fromJson(Map<String, dynamic> json) => UploadImagesModel(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
