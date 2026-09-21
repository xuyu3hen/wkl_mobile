import '../index.dart';

class VerifyApi extends BaseApi {
  // 到货列表（待核验）
  Future<Response> purchaseVerifyQuery(
    {required Map<String,dynamic> queryParameters}
  ) async {
    var r = await BaseApi.dio.post(
      '/purchase/verify/query',
      queryParameters: queryParameters,
    );
    print(r.data);
    return r;
  }

  // 仓库获取
  Future<Response> getStorePlace() async {
    var r = await BaseApi.dio.get(
      '/storePlace/query/storePlace',
    );
    print(r.data);
    return r;
  }

  // 库位获取
  Future<Response> getStoreLocation(
    {required String storePlaceId}
  ) async {
    var r = await BaseApi.dio.get(
      '/storePlace/query/storeLocation',
      queryParameters: {
        'storePlaceId': storePlaceId,
      },
    );
    print(r.data);
    return r;
  }

  // 入库核验
  Future<Response> verifyIn(
    {required Map<String,dynamic> queryParameters}
  ) async {
    var r = await BaseApi.dio.post(
      '/purchase/verify/basic',
      queryParameters: queryParameters,
    );
    print(r.data);
    return r;
  }
}