import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/module/checkout/checkout_page.dart';
import 'package:flutter_app_book_store/module/home/home_page.dart';
import 'package:flutter_app_book_store/shared/app_color.dart';

import 'module/signin/signin_page.dart';
import 'module/signup/signup_page.dart';
import 'module/splash/splash_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        primarySwatch: AppColor.yellow,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/checkout': (context) => const CheckOutPage(),
      },
    );
  }
}
