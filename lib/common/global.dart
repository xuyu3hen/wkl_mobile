import 'package:shared_preferences/shared_preferences.dart';
import 'package:wkl_mobile/index.dart';

/// 全局状态与持久化
///
/// 持久化字段：token / adminToken / isLogin
/// profile 不持久化，App 启动时若 token 有效则自动从服务端拉取最新值。
class Global {
  static bool isLogin = false;
  static Profile? profile;
  static String token = "";
  static String adminToken = "";

  static SharedPreferences? _prefs;

  // 持久化存储 key
  static const _kToken = 'g_token';
  static const _kAdminToken = 'g_admin_token';
  static const _kIsLogin = 'g_is_login';

  /// 初始化：从本地存储恢复登录态与 token
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    token = _prefs?.getString(_kToken) ?? "";
    adminToken = _prefs?.getString(_kAdminToken) ?? "";
    isLogin = _prefs?.getBool(_kIsLogin) ?? false;
  }

  /// 保存登录凭证（同步内存 + 持久化 + 恢复 Cookie）
  static Future<void> saveAuth(String token, String adminToken) async {
    Global.token = token;
    Global.adminToken = adminToken;
    await _prefs?.setString(_kToken, token);
    await _prefs?.setString(_kAdminToken, adminToken);
    await BaseApi.saveCookies(token, adminToken);
  }

  /// 设置登录状态并持久化
  static Future<void> setLogin(bool value) async {
    isLogin = value;
    await _prefs?.setBool(_kIsLogin, value);
  }

  /// 清除全部持久化数据（token 失效或登出时调用）
  static Future<void> clear() async {
    token = "";
    adminToken = "";
    isLogin = false;
    profile = null;
    await _prefs?.remove(_kToken);
    await _prefs?.remove(_kAdminToken);
    await _prefs?.remove(_kIsLogin);
  }

  /// 是否存在已保存的登录凭证
  static bool get hasSavedAuth => token.isNotEmpty && adminToken.isNotEmpty;
}
