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
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (Global.ruoyiToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${Global.ruoyiToken}';
        }
        // 请求日志（BEGIN/END 包裹，便于核对接口字段）
        debugPrint('================== BEGIN REQUEST ==================');
        debugPrint('${options.method} ${options.uri}');
        debugPrint('Headers: ${options.headers}');
        if (options.queryParameters.isNotEmpty) {
          debugPrint('Query: ${options.queryParameters}');
        }
        if (options.data != null) {
          debugPrint('Body: ${options.data}');
        }
        debugPrint('================== END REQUEST ==================');
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('================== BEGIN RESPONSE ==================');
        debugPrint('${response.statusCode} ${response.requestOptions.uri}');
        debugPrint('Data: ${response.data}');
        debugPrint('================== END RESPONSE ==================');
        handler.next(response);
      },
      onError: (e, handler) {
        debugPrint('================== BEGIN ERROR ==================');
        debugPrint('${e.response?.statusCode} ${e.requestOptions.uri}');
        debugPrint('Message: ${e.message}');
        if (e.response != null) {
          debugPrint('Data: ${e.response?.data}');
        }
        debugPrint('================== END ERROR ==================');
        handler.next(e);
      },
    ));
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