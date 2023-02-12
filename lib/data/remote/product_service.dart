import 'package:dio/dio.dart';
import 'package:flutter_app_book_store/network/book_client.dart';

class ProductService {
  Future<Response> getProducts() {
    return BookClient.instance.dio.get('/product/list');
  }
}
