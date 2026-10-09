import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_filex/open_filex.dart';

import '../models/global/myapkversion.dart';
import '../api/base_api.dart';

class UpdateManager {
  static final UpdateManager _instance = UpdateManager._internal();
  factory UpdateManager() => _instance;
  UpdateManager._internal();

  // 本地（当前安装包）版本信息
  String localVersion = '';
  int localBuildNumber = 0;

  /// 读取本地版本号
  Future<void> loadLocalVersion() async {
    final info = await PackageInfo.fromPlatform();
    localVersion = info.version;
    localBuildNumber = int.tryParse(info.buildNumber) ?? 0;
  }

  /// 版本号比较：remote > local 返回 true
  /// 按数字段逐段比较（如 1.10.0 > 1.9.0），忽略非数字字符，兼容 "1.2.3" / "v1.2" 等格式
  static bool isVersionHigher(String remote, String local) {
    List<int> parse(String v) => v
        .split('+')
        .first
        .split('.')
        .map((s) => int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .toList();
    final a = parse(remote);
    final b = parse(local);
    final len = max(a.length, b.length);
    for (var i = 0; i < len; i++) {
      final x = i < a.length ? a[i] : 0;
      final y = i < b.length ? b[i] : 0;
      if (x != y) return x > y;
    }
    return false;
  }

  // 检查版本更新：仅当服务端版本号高于本地时返回版本信息（返回 null 表示无需更新或检查失败）
  Future<MyApkVersion?> checkUpdate() async {
    try {
      await loadLocalVersion();

      // 走相对路径，自动使用当前 flavor 的 baseUrl 与鉴权 Header
      // TODO: 新后端版本接口路径待与后端确认，暂沿用原路径
      var response = await BaseApi.dio.get(
        "/main/get/apk/version/last",
      );
      if (response.data['code'] == 200) {
        final remote = MyApkVersion.fromJson(response.data["data"]);
        final remoteVersion = remote.version ?? '';
        if (isVersionHigher(remoteVersion, localVersion)) {
          return remote;
        }
      }
    } catch (e) {
      // 静默失败，不打扰正常使用
      print('检查更新失败：$e');
    }
    return null;
  }

  // 下载APK
  Future<void> downloadApk({
    required String url,
    required String savePath,
    required Function(double progress) onProgress,
    required Function() onComplete,
    required Function(String error) onError,
  }) async {
    try {

      await BaseApi.dio.download(
        url,
        savePath,
        onReceiveProgress: (count, total) {
          if (total > 0) {
            double progress = count / total;
            onProgress(progress);
          }
        },
      );
      onComplete();
    } catch (e) {
      onError('下载失败：$e');
    }
  }

  // 获取存储权限
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else {
        Fluttertoast.showToast(msg: '需要存储权限才能下载更新');
        return false;
      }
    }
    return true;
  }

  // 获取下载保存路径
  Future<String> getSavePath(String fileName) async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }
    String path = '${directory!.path}/$fileName';
    return path;
  }

  // 打开安装包
  static Future<void> openApk(String filePath) async {
    try {
      if (Platform.isAndroid) {
        // 使用open_filex插件打开APK文件
        final result = await OpenFilex.open(filePath);
        print('Open APK result: $result');
        
        if (result.type != ResultType.done) {
          Fluttertoast.showToast(msg: '打开APK失败: ${result.message}');
        }
      } else if (Platform.isIOS) {
        // iOS需要通过App Store更新，这里可以打开App Store链接
        Fluttertoast.showToast(msg: '请前往App Store更新');
      }
    } catch (e) {
      print('打开APK失败: $e');
      Fluttertoast.showToast(msg: '打开APK失败: $e');
      rethrow;
    }
  }
}