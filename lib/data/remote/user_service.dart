import 'package:dio/dio.dart';
import 'package:flutter_app_book_store/network/book_client.dart';

class UserService {
  Future<Response> signIn(String phone, String password) async {
    var response = await BookClient.instance.dio.post(
      '/user/sign-in',
      data: {
        'phone': phone,
        'password': password,
      },
    );
    return response;
  }

  Future<Response> signUp(
      String displayName, String phone, String password) async {
    return await BookClient.instance.dio.post('/user/sign-up', data: {
      'displayName': displayName,
      'phone': phone,
      'password': password
    });
  }
}
