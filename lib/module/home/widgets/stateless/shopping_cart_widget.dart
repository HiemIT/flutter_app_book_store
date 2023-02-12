import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/module/home/home_bloc.dart';
import 'package:provider/provider.dart';

import '../statefull/cart_widget.dart';

class ShoppingCartWidget extends StatelessWidget {
  const ShoppingCartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: HomeBloc.getInstance(
          productRepo: Provider.of(context),
          orderRepo: Provider.of(context),
        ),
        child:  CartWidget());
  }
}
