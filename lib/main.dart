
import 'package:flutter/services.dart';
import 'index.dart';
import 'app.dart';

void main() async {
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  WidgetsFlutterBinding.ensureInitialized();
  // 锁定竖屏，不允许左右翻转横屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await BaseApi.init();
  await Global.init();
  // 自动登录：本地存在有效凭证时，恢复 Cookie 并刷新用户信息
  await _tryAutoLogin();

  runApp(const App());
}

/// 若本地存在已保存的登录凭证，则恢复 Cookie 并自动拉取最新 profile。
/// token 失效（接口异常）时清除本地登录态，由路由守卫重定向至登录页。
Future<void> _tryAutoLogin() async {
  if (!Global.hasSavedAuth || !Global.isLogin) return;

  try {
    await BaseApi.saveCookies(Global.token, Global.adminToken);
    final r = await UserApi().getProfile();
    final code = r.data is Map ? r.data['code'] : null;
    if (r.statusCode == 200 && code == 200) {
      Global.profile = Profile.fromJson(r.data['data']);
    } else {
      // token 失效：清除本地登录态
      await Global.clear();
    }
  } catch (e) {
    // 网络/解析异常：保守起见清除登录态，避免进入死循环
    await Global.clear();
  }
}
