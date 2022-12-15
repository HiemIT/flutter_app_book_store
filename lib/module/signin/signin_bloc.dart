import 'dart:async';

import 'package:flutter_app_book_store/base/base_bloc.dart';
import 'package:flutter_app_book_store/base/base_even.dart';
import 'package:flutter_app_book_store/data/repo/user_repo.dart';
import 'package:flutter_app_book_store/event/signin_event.dart';
import 'package:flutter_app_book_store/shared/validation.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc extends BaseBloc {
  final _phoneSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  late UserRepo _userRepo;
  // SignInBloc({required UserRepo userRepo}) : _userRepo = userRepo {
  //   validateForm();
  // }

  SignInBloc({required UserRepo userRepo}) {
    _userRepo = userRepo;
    validateForm();
  }

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

  Stream<String> get phoneStream =>
      _phoneSubject.stream.transform(phoneValidator);
  Sink<String> get phoneSink => _phoneSubject.sink;
  //
  Stream<String> get passStream => _passSubject.stream.transform(passValidator);
  Sink<String> get passSink => _passSubject.sink;
  //
  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  validateForm() {
    CombineLatestStream.combine2(
      _phoneSubject,
      _passSubject,
      (phone, pass) {
        return Validation.isPhoneValid(phone) &&
            Validation.isPasswordValid(pass);
      },
    ).listen((enable) {
      btnSink.add(enable);
    });
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case SignInEvent:
        handleSignIn(event);
        break;
      default:
        break;
    }
  }

  handleSignIn(event) {
    SignInEvent e = event as SignInEvent;
    _userRepo.signIn(e.phone, e.password).then(
      (userData) {
        print(userData);
      },
      onError: (e) {
        print(e.toString());
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _phoneSubject.close();
    _passSubject.close();
    _btnSubject.close();
  }
}
