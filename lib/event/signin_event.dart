import 'package:flutter_app_book_store/base/base_even.dart';

class SignInEvent extends BaseEvent {
  late String phone;
  late String password;

  SignInEvent({required this.phone, required this.password});
}
