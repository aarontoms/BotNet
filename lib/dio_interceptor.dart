import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'main.dart';

final dio = Dio();

Future<void> setupDio() async {
  dio.interceptors.clear();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      if (!['/login', '/signup'].contains(options.uri.path)) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
      return handler.next(options);
    },

    onError: (DioException error, handler) async {
      if (error.response?.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        final secureStorage = FlutterSecureStorage();
        final refreshToken = await secureStorage.read(key: 'refresh_token');

        if (refreshToken != null) {
          try {
            final response = await dio.post(
              '$backendUrl/token-refresh',
              data: {'refreshToken': refreshToken},
            );

            final newAccessToken = response.data['accessToken'];
            await prefs.setString('access_token', newAccessToken);

            final options = error.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';
            final retryResponse = await dio.fetch(options);
            return handler.resolve(retryResponse);

          } catch (e) {
            await prefs.remove('access_token');
            await secureStorage.delete(key: 'refresh_token');

            Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil('/', (route) => false);
          }
        }
      }
      return handler.next(error);
    },
  ));
}
