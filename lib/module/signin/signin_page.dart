import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/base/base_even.dart';
import 'package:flutter_app_book_store/data/remote/user_service.dart';
import 'package:flutter_app_book_store/data/repo/user_repo.dart';
import 'package:flutter_app_book_store/event/signin_event.dart';
import 'package:flutter_app_book_store/event/signin_sucess_event.dart';
import 'package:flutter_app_book_store/module/signin/signin_bloc.dart';
import 'package:flutter_app_book_store/shared/widget/bloc_listener.dart';
import 'package:flutter_app_book_store/shared/widget/loading_task.dart';
import 'package:flutter_app_book_store/shared/widget/normal_button.dart';
import 'package:provider/provider.dart';

import '../../base/base_widget.dart';
import '../../event/signin_fail_event.dart';
import '../../shared/app_color.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      di: [
        Provider.value(
          value: UserService(),
        ),
        ProxyProvider<UserService, UserRepo>(
          update: (context, userService, previous) =>
              UserRepo(userService: userService),
        ),
        //Dùng ProxyProvider để lấy giá trị của userService và truyền vào UserRepo để sử dụng các hàm trong UserRepo như login, register, ...
      ],
      title: "Sign In",
      child: const SignInFormWidget(),
    );
  }
}

class SignInFormWidget extends StatefulWidget {
  const SignInFormWidget({Key? key}) : super(key: key);

  @override
  State<SignInFormWidget> createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  final TextEditingController _txtPhoneController = TextEditingController();

  final TextEditingController _txtPassController = TextEditingController();

  handleEvent(BaseEvent event) {
    if (event is SignInSuccessEvent) {
      Navigator.pushReplacementNamed(context, '/home');
    }

    if (event is SignInFailEvent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(event.errMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<SignInBloc>.value(
      value: SignInBloc(userRepo: Provider.of(context)),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, child) {
          return BlocListener<SignInBloc>(
            listener: handleEvent,
            child: LoadingTask(
              bloc: bloc,
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPhoneField(bloc),
                    _buildPassField(bloc),
                    buildSignInButton(bloc),
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhoneField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      //Dùng StreamProvider để lấy giá trị của stream phoneStream
      initialData: '',
      value: bloc.phoneStream, //Lấy giá trị của phoneStream từ SignInBloc
      child: Consumer<String>(
        //Dùng Consumer để lấy giá trị của stream phoneStream
        builder: (context, msg, child) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: TextField(
              controller: _txtPhoneController,
              onChanged: (text) {
                bloc.phoneSink.add(text); //Gửi giá trị của text vào phoneSink
              },
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.phone,
                    color: AppColor.blue,
                  ),
                  hintText: '(+84) 973 901 789',
                  errorText: msg,
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: AppColor.blue)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPassField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      initialData: '',
      value: bloc.passStream,
      child: Consumer<String>(
        builder: (context, msg, child) {
          return Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: TextField(
              controller: _txtPassController,
              onChanged: (text) {
                bloc.passSink.add(text); //Gửi giá trị của text vào passSink
              },
              obscureText: true,
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: AppColor.blue,
                ),
                hintText: 'Password',
                errorText: msg,
                labelText: 'Password',
                labelStyle: TextStyle(color: AppColor.blue),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSignInButton(SignInBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) => NormalButton(
          title: 'Sign In',
          onPressed: enable
              ? () {
                  bloc.event.add(
                    SignInEvent(
                      phone: _txtPhoneController.text,
                      password: _txtPassController.text,
                    ),
                  );
                }
              : null,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: TextStyle(color: AppColor.blue),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/sign-up');
            },
            child: Text(
              'Sign Up',
              style: TextStyle(color: AppColor.blue),
            ),
          )
        ],
      ),
    );
  }
}
