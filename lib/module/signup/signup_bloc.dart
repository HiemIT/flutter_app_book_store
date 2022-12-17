import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_book_store/base/base_bloc.dart';
import 'package:flutter_app_book_store/base/base_even.dart';
import 'package:flutter_app_book_store/data/repo/user_repo.dart';
import 'package:flutter_app_book_store/event/signup_even.dart';
import 'package:flutter_app_book_store/shared/validation.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends BaseBloc with ChangeNotifier {
  final _displayNameSubject = BehaviorSubject<String>();
  final _phoneSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  late UserRepo _userRepo;

  SignUpBloc({required UserRepo userRepo}) {
    _userRepo = userRepo;
  }

  var displayNameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (displayName, sink) {
      if (Validation.isDisplayNameValid(displayName) || displayName.isEmpty) {
        sink.add('');
        return;
      }
      sink.add('Display name is invalid');
    },
  );

  var phoneValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (phone, sink) {
      if (Validation.isPhoneValid(phone) || phone.isEmpty) {
        sink.add('');
        return;
      }
      sink.add('Phone is invalid');
    },
  );

  var passValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink) {
      if (Validation.isPasswordValid(pass) || pass.isEmpty) {
        sink.add('');
        return;
      } else {
        sink.add('Password is invalid');
      }
    },
  );

  // listen event
  // export event to StreamController
  Stream<String> get displayNameStream =>
      _displayNameSubject.stream.transform(displayNameValidator);

  Sink<String> get displayNameSink => _displayNameSubject.sink;

  Stream<String> get passStream => _passSubject.stream.transform(passValidator);

  Sink<String> get passSink => _passSubject.sink;

  //
  Stream<bool> get btnStream => _btnSubject.stream;

  Sink<bool> get btnSink => _btnSubject.sink;

  validateForm() {
    CombineLatestStream.combine3(
      _displayNameSubject,
      _phoneSubject,
      _passSubject,
      (displayName, phone, pass) {
        if (Validation.isDisplayNameValid(displayName) &&
            Validation.isPhoneValid(phone) &&
            Validation.isPasswordValid(pass)) {
          return true;
        }
        return false;
      },
    ).listen((enable) {
      btnSink.add(enable);
    });
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case SignUpEvent:
        handleSignUp(event as SignUpEvent);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    print('signUp dispose');
    _displayNameSubject.close();
    _phoneSubject.close();
    _passSubject.close();
    _btnSubject.close();
  }

  void handleSignUp(SignUpEvent event) {
    SignUpEvent e = event;
    _userRepo.signUp(e.displayName, e.phone, e.password).then(
      (userData) {
        print(userData);
      },
      onError: (error) {
        print(error);
      },
    );
  }
}
