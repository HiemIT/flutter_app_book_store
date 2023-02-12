import 'package:flutter_app_book_store/shared/model/product_model.dart';

class ShoppingCart {
  final String? orderId;
  int? total;
  final List<Product>? products;

  ShoppingCart({this.orderId, this.total, this.products});

  factory ShoppingCart.fromJson(Map<String, dynamic> json) {
    return ShoppingCart(
      orderId: json['orderId'],
      total: json['total'],
    );
  }


}
