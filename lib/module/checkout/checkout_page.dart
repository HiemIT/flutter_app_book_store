import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/base/base_widget.dart';
import 'package:flutter_app_book_store/data/remote/order_service.dart';
import 'package:flutter_app_book_store/data/repo/order_repo.dart';
import 'package:flutter_app_book_store/event/confirm_order_event.dart';
import 'package:flutter_app_book_store/event/pop_event.dart';
import 'package:flutter_app_book_store/shared/model/order.dart';
import 'package:flutter_app_book_store/shared/model/product_model.dart';
import 'package:flutter_app_book_store/shared/model/rest_error.dart';
import 'package:flutter_app_book_store/shared/widget/normal_button.dart';
import 'package:provider/provider.dart';

import '../../base/base_even.dart';
import '../../event/update_cart_event.dart';
import '../../shared/widget/bloc_listener.dart';
import '../../shared/widget/btn_cart_action.dart';
import 'checkout_bloc.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  Widget build(BuildContext context) {
    final String orderId = ModalRoute.of(context)!.settings.arguments as String;
    return PageContainer(
      isShowAppBar: true,
      title: 'Checkout',
      di: [
        Provider.value(
          value: orderId,
        ),
        Provider.value(
          value: OrderService(),
        ),
        ProxyProvider2<OrderService, String, OrderRepo>(
          update: (context, orderService, orderId, previous) => OrderRepo(
            orderService: orderService,
            orderId: orderId,
          ),
        ),
      ],
      bloc: [],
      child: const ShoppingCartContainer(),
    );
  }
}

class ShoppingCartContainer extends StatefulWidget {
  const ShoppingCartContainer({super.key});

  @override
  _ShoppingCartContainerState createState() => _ShoppingCartContainerState();
}

class _ShoppingCartContainerState extends State<ShoppingCartContainer> {
  handleEvent(BaseEvent event) {
    if (event is ShouldPopEvent) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(

      create: (_) => CheckoutBloc(
        orderRepo: Provider.of(context),
      ),
      child: Consumer<CheckoutBloc>(
        builder: (context, bloc, child) => BlocListener<CheckoutBloc>(
          listener: handleEvent,
          child: ShoppingCart(bloc),
        ),
      ),
    );
  }
}

class ShoppingCart extends StatefulWidget {
  final CheckoutBloc bloc;

  const ShoppingCart(this.bloc, {super.key});

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  void initState() {
    super.initState();
    widget.bloc.getOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Object?>.value(
      value: widget.bloc.orderStream,
      initialData: null,
      catchError: (context, err) {
        return err;
      },
      child: Consumer<Object?>(
        builder: (context, data, child) {
          if (data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (data is RestError) {
            return Center(
                child: Container(
              child: Text(data.message!),
            ));
          }

          if (data is Order) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ProductListWidget(data.items!),
                ),
                ConfirmInfoWidget(data.total),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class ProductListWidget extends StatelessWidget {
  final List<Product> productList;

  const ProductListWidget(this.productList, {super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CheckoutBloc>(context);
    productList.sort((p1, p2) => p1.price!.compareTo(p2.price!));
    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (context, index) => _buildRow(productList[index], bloc),
    );
  }

  Widget _buildRow(Product product, CheckoutBloc bloc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.productImage!,
                width: 90,
                height: 140,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.productName!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15.0,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Giá: ${product.price} đ',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  _buildCartAction(product, bloc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartAction(Product product, CheckoutBloc bloc) {
    return Row(
      children: <Widget>[
        BtnCartAction(
          title: '-',
          onPressed: () {
            if (product.quantity == 1) {
              return;
            }
            product.quantity = product.quantity! - 1;
            bloc.event.add(UpdateCartEvent(product));
          },
        ),
        const SizedBox(
          width: 15,
        ),
        Text('${product.quantity}',
            style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.red)),
        const SizedBox(
          width: 15,
        ),
        BtnCartAction(
          title: '+',
          onPressed: () {
            product.quantity = product.quantity! + 1;
            bloc.event.add(UpdateCartEvent(product));
          },
        ),
      ],
    );
  }
}

class ConfirmInfoWidget extends StatelessWidget {
  final double? total;
  const ConfirmInfoWidget(this.total,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutBloc>(
  builder: (context, bloc, child) {
  return Container(
      height: 170,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${total} đ',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Colors.blue),
          ),
          const SizedBox(
            height: 20.0,
          ),
          NormalButton(
            title: 'Confirm',
            onPressed: () {
              bloc.event.add(ConfirmOrderEvent());
            },
          ),
        ],
      ),
    );
  },
);

  }
}
