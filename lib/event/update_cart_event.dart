import 'package:flutter_app_book_store/shared/model/product_model.dart';

import '../base/base_even.dart';

class UpdateCartEvent extends BaseEvent {
  Product product;

  UpdateCartEvent(this.product);
}
