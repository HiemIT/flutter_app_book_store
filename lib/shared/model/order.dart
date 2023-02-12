import 'package:flutter_app_book_store/shared/model/product_model.dart';

class Order {
  double? total;
  List<Product>? items;

  Order({
    this.total,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        total: json["total"].toDouble(),
        items: parseProductList(json),
      );

  static List<Product> parseProductList(map) {
    var list = map['items'] as List;
    return list.map((product) => Product.fromJson(product)).toList();
  }
}
