
import '../index.dart';

class UserApi extends BaseApi {
  
  // 登录函数
  Future<Response> login({required Map<String,dynamic> queryParameters}) async {
    print(queryParameters);
    var r = await BaseApi.dio.get(
      '/user/login/password',
      queryParameters:queryParameters
    );
    return r;
  }

  Future<Response> getProfile() async {
    var r = await BaseApi.dio.get(
      '/user/getUserInfo',
    );
    print(r.data);
    return r;
  }
}