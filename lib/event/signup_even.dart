import 'package:flutter_app_book_store/base/base_even.dart';

class SignUpEvent extends BaseEvent {
  late String displayName;
  late String phone;
  late String password;

  SignUpEvent(
      {required this.displayName, required this.phone, required this.password});
}
