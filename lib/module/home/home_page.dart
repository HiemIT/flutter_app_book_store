import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/base/base_widget.dart';
import 'package:flutter_app_book_store/data/remote/order_service.dart';
import 'package:flutter_app_book_store/data/remote/product_service.dart';
import 'package:flutter_app_book_store/data/repo/order_repo.dart';
import 'package:flutter_app_book_store/event/add_to_cart_event.dart';
import 'package:flutter_app_book_store/module/home/home_bloc.dart';
import 'package:flutter_app_book_store/module/home/widgets/stateless/shopping_cart_widget.dart';
import 'package:flutter_app_book_store/shared/app_color.dart';
import 'package:flutter_app_book_store/shared/model/product_model.dart';
import 'package:flutter_app_book_store/shared/model/rest_error.dart';
import 'package:provider/provider.dart';

import '../../data/repo/product_repo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Gopher',
      di: [
        Provider.value(
          value: ProductService(),
        ),
        Provider.value(
          value: OrderService(),
        ),
        ProxyProvider<ProductService, ProductRepo>(
          update: (context, productService, previous) =>
              ProductRepo(productService: productService),
        ),
        ProxyProvider<OrderService, OrderRepo>(
          update: (context, orderService, previous) =>
              OrderRepo(orderService: orderService, orderId: ''),
        ),
      ],
      bloc: [],
      child: const ProductListWidget(),
    );
  }
}

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeBloc.getInstance(
        productRepo: Provider.of(context),
        orderRepo: Provider.of(context),
      ),
      child: Consumer<HomeBloc>(
        builder: (context, bloc, child) => Container(
          child: StreamProvider<Object?>.value(
            value: bloc.getProducts(),
            initialData: null,
            catchError: (context, error) {
              return error;
            },
            child: Consumer<Object?>(
              builder: (context, data, child) {
                if (data == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: AppColor.yellow,
                    ),
                  );
                }

                if (data is RestError) {
                  return Center(
                    child: Container(
                      child: Text(
                        data.message!,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }

                var products = data as List<Product>;

                return RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(const Duration(seconds: 1), () {
                      bloc.getProducts();
                      bloc.getShoppingCartInfo();
                    });
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        centerTitle: true,
                        title: const Text(
                          'COOK STORE',
                          style: TextStyle(color: Colors.white),
                        ),
                        floating: true,
                        snap: true,
                        expandedHeight: 50,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            color: Colors.yellow,
                          ),
                        ),
                        actions: const <Widget>[
                          ShoppingCartWidget(),
                        ],
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return _buildRow(bloc, products[index]);
                          },
                          childCount: products.length,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(HomeBloc bloc, Product product) {
    return Container(
      height: 180,
      child: Card(
        shadowColor: Colors.black,
        elevation: 3.0,
        child: Container(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.productImage!,
                  width: 100,
                  height: 150,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                          const EdgeInsets.only(top: 15, left: 15, right: 10),
                      child: Text(
                        '${product.productName}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, left: 15),
                      child: Text(
                        '${product.quantity} quấn',
                        style: TextStyle(color: AppColor.blue, fontSize: 17),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 5, left: 15),
                            child: Text(
                              '${product.price} VND',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColor.yellow,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                bloc.event.add(AddToCartEvent(product));
                              },
                              child: const Text(
                                ' Buy now ',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
