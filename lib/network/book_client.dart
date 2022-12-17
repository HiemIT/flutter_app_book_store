import 'package:dio/dio.dart';

import '../db/spref/spref.dart';
import '../shared/constant.dart';

class BookClient {
  static final BaseOptions _options = BaseOptions(
    baseUrl: 'http://192.168.0.123:8000',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  static final Dio _dio = Dio(_options);

  BookClient._internal() {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await SPref.instance.get(SPrefCache.KEY_TOKEN);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  static final BookClient instance = BookClient._internal();

  Dio get dio => _dio;
}
