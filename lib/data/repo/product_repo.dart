import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/data/remote/product_service.dart';
import 'package:flutter_app_book_store/shared/model/product_model.dart';
import 'package:flutter_app_book_store/shared/model/rest_error.dart';

class ProductRepo {
  final ProductService _productService;

  ProductRepo({ProductService? productService})
      : _productService = productService!;

  Future<List<Product>> getProducts() async {
    var c = Completer<List<Product>>();
    try {
      var response = await _productService.getProducts();
      var products = Product.parseProductList(response.data);
      c.complete(products);
    } on DioError {
      c.completeError(RestError.fromData('Không có dữ liệu'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }
}
