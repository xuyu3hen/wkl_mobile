import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../index.dart';
class BaseApi {
  BuildContext? context;
  late Options apiOptions;

  BaseApi([this.context]){
    apiOptions = Options(extra: {"context":context});
  }

  static final Dio dio = Dio(BaseOptions(
    baseUrl: F.baseURL,
    headers: {
      HttpHeaders.acceptHeader:"application/json,"
        "*/*",
    }
  ));

  static CookieJar? _cookieJar;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(_cookieJar!));
    _initialized = true;
  }

  static Future<void> saveCookies(String token, String adminToken) async {
    final uri = Uri.parse(dio.options.baseUrl);
    await _cookieJar?.saveFromResponse(uri, [
      Cookie('mdmtesttoken', token),
      Cookie('Admin-Token', adminToken),
    ]);
  }
}