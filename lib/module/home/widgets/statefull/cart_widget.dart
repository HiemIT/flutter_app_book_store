import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/shared/model/rest_error.dart';
import 'package:flutter_app_book_store/shared/model/shopping_cart.dart';
import 'package:provider/provider.dart';

import '../../home_bloc.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var bloc = Provider.of<HomeBloc>(context);
    bloc.getShoppingCartInfo();
  }

  @override
  Widget build(BuildContext context) { 
    return Consumer<HomeBloc>(
      builder: (context, bloc, child) => StreamProvider<Object?>.value(
        value: bloc.shoppingCardStream,
        initialData: null,
        catchError: (context, error) {
          return error;
        },
        child: Consumer<Object?>(
          builder: (context, data, child) {
            if (data == null || data is RestError) {
              return Container(
                margin: const EdgeInsets.only(top: 15, right: 20),
                child: const Icon(Icons.shopping_cart),
              );
            }

            var cart = data as ShoppingCart;
            return GestureDetector(
              onTap: () {
                if (data == null) {
                  return;
                }
                Navigator.pushNamed(context, '/checkout',
                    arguments: cart.orderId);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 15, right: 20),
                child: Badge(
                  badgeContent: Text(
                    '${cart.total}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Icon(Icons.shopping_cart),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}