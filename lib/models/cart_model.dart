// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  bool success;
  Data data;

  CartModel({
    this.success,
    this.data,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  List<Cart> cart;

  Data({
    this.cart,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    cart: json["cart"] == null ? null : List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cart": cart == null ? null : List<dynamic>.from(cart.map((x) => x.toJson())),
  };
}

class Cart {
  int id;
  String name;
  String image;
  int quantity;

  Cart({
    this.id,
    this.name,
    this.image,
    this.quantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    quantity: json["quantity"] == null ? null : json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "quantity": quantity == null ? null : quantity,
  };
}
