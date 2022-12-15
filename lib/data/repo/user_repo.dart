import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app_book_store/data/remote/user_service.dart';
import 'package:flutter_app_book_store/db/spref/spref.dart';
import 'package:flutter_app_book_store/shared/constant.dart';
import 'package:flutter_app_book_store/shared/model/user_data.dart';

class UserRepo {
  final UserService _userService;

  UserRepo({required UserService userService}) : _userService = userService;

  Future<UserData> signIn(String phone, String password) async {
    var c = Completer<UserData>();
    try {
      var response = await _userService.signIn(phone, password);
      var userData = UserData.fromJson(response.data['data']);
      SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token);
      c.complete(userData);
    } on DioError {
      c.completeError('Đăng nhập thất bại');
    } catch (e) {
      c.completeError(e);
    }

    return c.future;
  }

  Future<UserData> signUp(
      String displayName, String phone, String password) async {
    var c = Completer<UserData>();
    try {
      var response = await _userService.signUp(displayName, phone, password);
      var userData = UserData.fromJson(response.data['data']);
      SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token);
      c.complete(userData);
    } on DioError {
      c.completeError('Đăng ký thất bại');
    } catch (e) {
      c.completeError(e);
    }

    return c.future;
  }
}
