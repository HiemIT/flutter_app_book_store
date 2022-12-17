import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/base/base_even.dart';
import 'package:rxdart/subjects.dart';

abstract class BaseBloc {
  // StreamController
  final StreamController<BaseEvent> _processEventSubject =
      BehaviorSubject<BaseEvent>();

  final StreamController<bool> _loadingStreamController =
      StreamController<bool>();

  final StreamController<BaseEvent> _eventStreamController =
      StreamController<BaseEvent>();

  Sink<BaseEvent> get event => _eventStreamController.sink;

  Stream<bool> get loadingStream => _loadingStreamController.stream;

  Sink<bool> get loadingSink => _loadingStreamController.sink;

  Stream<BaseEvent> get processEventStream => _processEventSubject.stream;

  Sink<BaseEvent> get processEventSink => _processEventSubject.sink;

  BaseBloc() {
    _eventStreamController.stream.listen((event) {
      if (event is! BaseEvent) {
        throw Exception("Invalid event");
      }

      dispatchEvent(event);
    });
  }

  void dispatchEvent(BaseEvent event); // abstract method (phương thức trừu tượng) để xử lý các sự kiện từ các lớp con

  @mustCallSuper
  void dispose() {
    _eventStreamController.close();
    _loadingStreamController.close();
    _processEventSubject.close();
  }
}
