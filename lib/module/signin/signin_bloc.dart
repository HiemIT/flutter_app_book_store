import 'dart:async';

import 'package:flutter_app_book_store/base/base_bloc.dart';
import 'package:flutter_app_book_store/base/base_even.dart';
import 'package:flutter_app_book_store/data/repo/user_repo.dart';
import 'package:flutter_app_book_store/event/signin_event.dart';
import 'package:flutter_app_book_store/event/signin_fail_event.dart';
import 'package:flutter_app_book_store/event/signin_sucess_event.dart';
import 'package:flutter_app_book_store/shared/model/user_data.dart';
import 'package:flutter_app_book_store/shared/validation.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc extends BaseBloc {
  final _phoneSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  final _userSubject = BehaviorSubject<UserData>();

  late UserRepo _userRepo;

  // SignInBloc({required UserRepo userRepo}) : _userRepo = userRepo {
  //   validateForm();
  // }

  SignInBloc({required UserRepo userRepo}) {
    _userRepo = userRepo;
    validateForm();
  }

  var phoneValidator = StreamTransformer<String, String>.fromHandlers(
    // StreamTransformer là một lớp để xử lý dữ liệu trước khi đưa vào Stream
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
        sink.add('Password too short');
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

  Stream<UserData> get userStream => _userSubject.stream;

  Sink<UserData> get userSink => _userSubject.sink;

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
    btnSink.add(false); // khi bắt đầu call api thì disable button sign in
    loadingSink.add(true); // hiển thị loading

    //   call api
    Future.delayed(
      const Duration(seconds: 6),
      () {
        SignInEvent e = event as SignInEvent;
        _userRepo.signIn(e.phone, e.password).then(
          (userData) {
            processEventSink.add(SignInSuccessEvent(userData));
          },
          onError: (e) {
            btnSink.add(true); //Khi có kết quả thì enable nút sign-in trở lại
            loadingSink.add(false); // hide loading
            processEventSink
                .add(SignInFailEvent(e.toString())); // thông báo kết quả
          },
        );
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
