import 'dart:async';
import 'dart:io';

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

  // 检查版本更新
  Future<MyApkVersion?> checkUpdate() async {
    try {

      var response = await BaseApi.dio.get(
        "https://10.102.12.211:8085/main/get/apk/version/last",
      );
      if (response.data['code'] == 200) {
        return MyApkVersion.fromJson(response.data["data"]);
      }
    } catch (e) {
      print('检查更新失败：$e');
      Fluttertoast.showToast(msg: '检查更新失败');
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