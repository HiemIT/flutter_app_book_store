import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/base/base_bloc.dart';
import 'package:flutter_app_book_store/base/base_even.dart';
import 'package:flutter_app_book_store/data/repo/order_repo.dart';
import 'package:flutter_app_book_store/event/confirm_order_event.dart';
import 'package:flutter_app_book_store/event/pop_event.dart';
import 'package:flutter_app_book_store/event/update_cart_event.dart';
import 'package:flutter_app_book_store/shared/model/order.dart';
import 'package:rxdart/rxdart.dart';

class CheckoutBloc extends BaseBloc with ChangeNotifier {
  final OrderRepo _orderRepo;

  CheckoutBloc({required OrderRepo orderRepo}) : _orderRepo = orderRepo;

  final _orderSubject = BehaviorSubject<Order>();

  Stream<Order> get orderStream => _orderSubject.stream;

  Sink<Order> get orderSink => _orderSubject.sink;

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case UpdateCartEvent:
        handleUpdateCart(event);
        break;
      case ConfirmOrderEvent:
        handleConfirmOrder(event);
        break;
    }
  }

  // Về cơ bản, phương thức này được sử dụng để cập nhật
  // thông tin cho một đơn hàng và lấy chi tiết của đơn hàng đó
  // bằng cách sử dụng các phương thức updateOrder và  getOrderDetail.`
  handleUpdateCart(BaseEvent event) {
    UpdateCartEvent e = event as UpdateCartEvent;

    //   khởi tạo Observable stream từ future
    Stream.fromFuture(_orderRepo.updateOrder(e.product))
        .flatMap((value) => Stream.fromFuture(_orderRepo.getOrderDetail()))
        .listen((event) {
      orderSink.add(event);
    }, onError: (e) {
      print(e);
    });
  }

  handleConfirmOrder(BaseEvent event) {
    _orderRepo.confirmOrder().then((isSuccess) {
      processEventSink.add(ShouldPopEvent());
    });
  }
  getOrderDetail() {
    Stream<Order>.fromFuture(
      _orderRepo.getOrderDetail(),
    ).listen((order) {
      orderSink.add(order);
    });
  }
}
