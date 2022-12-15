import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/base/base_even.dart';

abstract class BaseBloc {
  // StreamController
  final StreamController<BaseEvent> _controller = StreamController.broadcast();
  // sink
  Sink<BaseEvent> get sink => _controller.sink;

  final StreamController<bool> _loadingStreamController =
      StreamController<bool>();

  Stream<bool> get loadingStream => _loadingStreamController.stream;
  Sink<bool> get loadingSink => _loadingStreamController.sink;

  BaseBloc() {
    _controller.stream.listen((event) {
      dispatchEvent(event);
    });
  }

  void dispatchEvent(BaseEvent event);

  @mustCallSuper
  void dispose() {
    _controller.close();
    _loadingStreamController.close();
  }
}
