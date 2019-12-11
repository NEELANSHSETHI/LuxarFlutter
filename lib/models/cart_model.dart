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
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };
}

class Data {
  List<Cart> cart;

  Data({
    this.cart,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    cart: List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
  };
}

class Cart {
  int id;
  String name;
  String image;
  int quantity;
  int price;

  Cart({
    this.id,
    this.name,
    this.image,
    this.quantity,
    this.price,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    quantity: json["quantity"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "quantity": quantity,
    "price": price,
  };
}
