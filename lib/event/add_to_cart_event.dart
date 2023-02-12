import 'package:flutter_app_book_store/base/base_even.dart';
import 'package:flutter_app_book_store/shared/model/product_model.dart';

class AddToCartEvent extends BaseEvent {
  final Product product;

  AddToCartEvent(this.product);
}
