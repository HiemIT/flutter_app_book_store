import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/base/base_widget.dart';
import 'package:flutter_app_book_store/data/remote/user_service.dart';
import 'package:flutter_app_book_store/data/repo/user_repo.dart';
import 'package:flutter_app_book_store/shared/app_color.dart';
import 'package:flutter_app_book_store/shared/widget/normal_button.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: "Sign",
      bloc: [],
      di: [
        Provider.value(
          value: UserService(),
        ),
        ProxyProvider<UserService, UserRepo>(
          update: (context, userService, previous) =>
              UserRepo(userService: userService),
        ),
      ],
      child: SignUpFormWidget(),
    );
  }
}

class SignUpFormWidget extends StatefulWidget {
  SignUpFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final TextEditingController _txtPhoneController = TextEditingController();

  final TextEditingController _txtPassController = TextEditingController();

  final TextEditingController _txtDisplayNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: TextField(
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Display Name",
                icon: const Icon(Icons.person, color: Colors.blue),
                labelText: "Display Name",
                labelStyle: TextStyle(color: AppColor.blue),
                errorText: "Display Name is required",
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: TextField(
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.phone,
                  color: AppColor.blue,
                ),
                hintText: '(+84) 973 901 789',
                labelText: 'Phone',
                errorText: 'Phone is required',
                labelStyle: TextStyle(color: AppColor.blue),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: TextField(
              cursorColor: Colors.black,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: AppColor.blue,
                ),
                hintText: 'Password',
                labelText: 'Password',
                errorText: "Password is required",
                labelStyle: TextStyle(color: AppColor.blue),
              ),
            ),
          ),
          NormalButton(
            onPressed: () {},
            title: "Sign Up",
          ),
        ],
      ),
    );
  }
}
