import 'package:flutter/widgets.dart';
import 'package:flutter_app_book_store/base/base_bloc.dart';
import 'package:flutter_app_book_store/base/base_even.dart';
import 'package:flutter_app_book_store/data/repo/order_repo.dart';
import 'package:flutter_app_book_store/data/repo/product_repo.dart';
import 'package:flutter_app_book_store/event/add_to_cart_event.dart';
import 'package:flutter_app_book_store/shared/model/product_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../shared/model/shopping_cart.dart';

class HomeBloc extends BaseBloc with ChangeNotifier {
  // khai báo biến
  final ProductRepo _productRepo;
  final OrderRepo _orderRepo;

  var _shoppingCart = ShoppingCart();

  // khởi tạo biến
  static HomeBloc? _instance;

  static HomeBloc getInstance({required ProductRepo productRepo ,required OrderRepo orderRepo}) {
    _instance = HomeBloc._internal(productRepo: productRepo, orderRepo: orderRepo);
    return _instance!;
  }

  factory HomeBloc() {
    return _instance!;
  }

  HomeBloc._internal({required ProductRepo productRepo, required OrderRepo orderRepo})
      : _productRepo = productRepo,
        _orderRepo = orderRepo;

  final _shoppingCardSubject = BehaviorSubject<ShoppingCart>();

  Stream<ShoppingCart> get shoppingCardStream => _shoppingCardSubject.stream;

  Sink<ShoppingCart> get shoppingCardSink => _shoppingCardSubject.sink;

  getShoppingCartInfo() {
    Stream<ShoppingCart>.fromFuture(_orderRepo.getShoppingCartInfo()).listen(
            (shoppingCart) {
          _shoppingCart = shoppingCart;
          shoppingCardSink.add(shoppingCart);
        }, onError: (err) {
      _shoppingCardSubject.addError(err);
    });
  }

  // xử lý các sự kiện từ các lớp con
  Stream<List<Product>> getProducts() {
    return Stream<List<Product>>.fromFuture(_productRepo.getProducts());
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case AddToCartEvent:
        handleAddToCart(event as AddToCartEvent);
        break;
    }
  }

  handleAddToCart(event) {
    AddToCartEvent addToCartEvent = event as AddToCartEvent;
    _orderRepo
        .addToCart(addToCartEvent.product)
        .then((shoppingCart) => {shoppingCardSink.add(shoppingCart)});
  }

  @override
  dispose() {
    _shoppingCardSubject.close();
    super.dispose();
  }
}
