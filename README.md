# 客车管理子系统（手持机） · wkl_mobile

基于 Flutter 开发的车站客运管理手持端 App，覆盖 BOM（票务）核销、验证、采购单据查看与操作等核心作业场景，提供离线可用的凭证恢复、版本内自动更新、相册/拍照附件上传等能力。

---

## 功能概览

- 用户登录 + 持久化 Cookie + 启动自动恢复登录态（`lib/main.dart` `_tryAutoLogin`）
- 路由守卫：未登录自动重定向至登录页（go_router）
- BOM 验证：未核销 / 已核销 单据列表与详情
- 采购单据查看：按分类 Tab 切换，支持关键字搜索与分页
- 应用内 APK 更新：下载 → 校验 → 调起安装（`update_manager.dart`）
- 本地凭证与配置：shared_preferences 持久化
- 图片/相册选择器（微信 UI：wechat_assets_picker / wechat_camera_picker）
- 多 Flavor 打包：dev / test / release / release_32，各自独立 appId 与图标

---

## 环境要求

| 项 | 版本 | 说明 |
|----|------|------|
| Flutter | **3.22.3** (stable) | SDK 最低约束 `>=3.4.3 <4.0.0`（见 `pubspec.yaml`） |
| Dart | 3.4.4 | 随 Flutter 3.22.3 绑定 |
| Android SDK Build Tools | 28.0.3+ | 建议通过 Android Studio SDK Manager 升级到 30+ |
| JDK | 17 | 已在 `android/gradle.properties` 中 `org.gradle.java.home` 指定，避免误用 Android Studio jbr 21 |
| Gradle | 7.6.3 | wrapper 固定，见 `gradle/wrapper/gradle-wrapper.properties` |
| Android Gradle Plugin | 7.3.0 | 见 `android/settings.gradle` |
| Kotlin | 1.7.10 | 见 `android/settings.gradle` |

> ⚠️ 如本地 Flutter 版本偏高（3.27+），sensors_plus / camera_android_camerax 等插件会使用 Flutter 3.27+ 新增的 `SurfaceProducer` Android Embedding API，与当前 AGP 7.3 / Kotlin 1.7.10 不兼容，项目已通过 `dependency_overrides` + 固定 wechat_camera_picker 版本规避。详见 [pubspec.yaml](pubspec.yaml)。

---

## 本地运行（env_dev）

```bash
# 1. 拉取依赖（国内镜像已在 Flutter pub 侧默认配置 storage.flutter-io.cn）
flutter pub get --no-example

# 2. 连接 Android 设备（USB 调试打开，或启动模拟器）
flutter devices

# 3. 运行开发 Flavor
flutter run --flavor env_dev -t lib/main.dart
```

若设备显示离线，尝试：

```bash
adb kill-server ; adb start-server ; adb devices
```

---

## 打包命令

```bash
# Debug（安装测试最快）
flutter build apk --debug   --flavor env_dev       -t lib/main.dart

# Release 正式版（64-bit）
flutter build apk --release --flavor env_release    -t lib/main.dart

# Release 32-bit 手持机专用
flutter build apk --release --flavor env_release_32 -t lib/main.dart

# 测试环境
flutter build apk --release --flavor env_test      -t lib/main.dart
```

产物目录：`build/app/outputs/flutter-apk/`，文件名形如 `app-env_dev-debug.apk`。

---

## Flavor 对照（flutter_flavorizr 管理）

见 `flavorizr.yaml`。

| Flavor | 应用名 | Android applicationId | 后端 baseURL | 图标 |
|--------|--------|-----------------------|--------------|------|
| `env_dev` | 客车管理（本地测试） | `ck.wkl_mobile_dev` | `http://10.105.84.170:8080` | 默认 Flutter 图标 |
| `env_test` | 客车管理子系统（测试） | `ck.wkl_mobile_test` | `http://10.102.81.68:9000/publictest` | `assets/icons/icon_test.jpg` |
| `env_release` | 客车管理子系统 | `ck.wkl_mobile_release` | `https://wkl.wkl.com` | `assets/icons/icon_release.png` |
| `env_release_32` | 客车管理子系统 | `ck.wkl_mobile_release_32` | `https://wkl.wkl.com` | `assets/icons/icon_release_x32.png` |

新增/修改 Flavor：编辑 `flavorizr.yaml` 后执行 `flutter pub run flutter_flavorizr`。

---

## 目录结构

```
wkl_mobile/
├─ lib/
│  ├─ api/                          # Dio 封装 & 业务接口
│  │   ├─ base_api.dart             # CookieJar / 拦截器 / 统一错误处理
│  │   ├─ user_api.dart             # 登录 / 个人资料
│  │   └─ verify_api.dart           # BOM 验证、采购单据相关接口
│  ├─ common/
│  │   ├─ global.dart               # 全局状态：token / profile / 持久化读写
│  │   ├─ update_manager.dart       # 应用内 APK 更新（下载+校验+安装）
│  │   └─ funs.dart                 # 通用工具函数
│  ├─ config/
│  │   ├─ colors.dart               # 主题色板
│  │   └─ gorouter_list.dart        # 路由表（go_router，含守卫）
│  ├─ models/                       # JSON 模型，json_serializable 生成 *.g.dart
│  │   ├─ global/                   # profile / 分页 / 版本号
│  │   └─ bom/verify/               # 采购、核销单据模型
│  ├─ routes/
│  │   ├─ login_page.dart
│  │   ├─ home_page.dart
│  │   └─ bom/verify/               # 核销主入口 / 未核销 / 已核销
│  ├─ pages/my_home_page.dart
│  ├─ zjc_module/                   # UI 基础组件库（自研）
│  │   ├─ utils/                    # 屏幕适配 / 权限 / 状态栏 / 图片 / 颜色…
│  │   ├─ widgets/                  # Badge、Dialog、AssetPicker、EmptyView、ProgressHUD…
│  │   ├─ zjc_form/                 # 表单输入、搜索框、选择 Cell
│  │   └─ base_appbar.dart
│  ├─ app.dart                      # MaterialApp + theme + router 装配
│  ├─ flavors.dart                  # Flavor 枚举 & baseURL / 标题映射
│  ├─ index.dart                    # 统一 barrel 导出
│  └─ main.dart                     # 入口：初始化、自动登录恢复、runApp
├─ android/                         # Android 原生层 & Gradle 构建
│  ├─ app/flavorizr.gradle
│  └─ gradle.properties             # 重要：JDK 17 路径、Maven 国内镜像 jvmargs
├─ assets/
│  ├─ icons/                        # 各 Flavor 图标
│  └─ images/                       # 登录背景、Logo 等静态资源
├─ flavorizr.yaml                   # Flavor 定义（flutter_flavorizr）
├─ pubspec.yaml                     # 依赖 & dependency_overrides（sensors_plus 6.x）
└─ analysis_options.yaml
```

---

## 核心依赖

| 包 | 用途 | 备注 |
|----|------|------|
| `dio` + `cookie_jar` + `dio_cookie_manager` | 网络请求 & Cookie 持久化 | 登录态复用 |
| `go_router` | 声明式路由 + 守卫 | 未登录 → `/login` 重定向 |
| `flutter_smart_dialog` | 智能弹窗 / Loading | |
| `bot_toast` | 轻量 Toast 组件 | |
| `wechat_assets_picker` / `wechat_camera_picker` | 微信风格相册 / 拍照 | 固定 `wechat_camera_picker: 4.3.7`（兼容 Flutter 3.22） |
| `permission_handler` | 相机 / 存储 / 定位权限申请 | |
| `device_info_plus` / `package_info_plus` | 设备 & 版本信息 | 自动更新版本比对 |
| `shared_preferences` | KV 本地持久化 | token、profile、主题等 |
| `path_provider` + `open_filex` | APK 下载后打开安装 | 应用内更新用 |
| `cached_network_image` | 网络图片缓存 | |
| `flutter_screenutil` | 屏幕像素适配 | |
| `json_serializable` / `build_runner` | JSON↔Dart 模型代码生成 | 重新生成：`dart run build_runner build --delete-conflicting-outputs` |
| `flutter_flavorizr` | 多环境打包（dev/test/release/release_32） | 见 `flavorizr.yaml` |
| `sensors_plus: 6.0.1` | 传感器（传递依赖覆盖） | `dependency_overrides` 固定，避免 7.x kts 新语法 |

> 所有依赖版本可执行 `flutter pub outdated` 查看是否有可升级版本。

---

## 代码生成（JSON 模型）

当修改 `lib/models/**/*.dart` 中的 `@JsonSerializable()` 类后：

```bash
dart run build_runner build --delete-conflicting-outputs
```

会同步更新同目录下对应的 `*.g.dart` 生成文件。

---

## 国内镜像（已默认配置）

### Flutter Pub 镜像（Flutter SDK 环境变量）
```
PUB_HOSTED_URL=https://pub.flutter-io.cn
FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

### Android Gradle Maven 镜像（已写入 `android/settings.gradle` / `build.gradle`）
- Google 镜像：`https://maven.aliyun.com/repository/google`
- Public 镜像：`https://maven.aliyun.com/repository/public`
- Gradle 插件镜像：`https://maven.aliyun.com/repository/gradle-plugin`
- 华为云备用：`https://repo.huaweicloud.com/repository/google/`、`.../maven/`
- 原始 `google()` / `mavenCentral()` / `gradlePluginPortal()` 作为兜底

### TLS 兼容（已写入 gradle.properties `org.gradle.jvmargs`）
```
-Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2,TLSv1.3
-Djdk.tls.client.protocols=TLSv1,TLSv1.1,TLSv1.2,TLSv1.3
```

---

## 常见构建失败排查

| 报错 | 根因 | 处理 |
|------|------|------|
| `requires SDK version >=3.4.3 <4.0.0` | 本地 Dart SDK 过旧 | 升级或切换到 Flutter 3.22.3+ |
| `Remote host terminated the handshake` (TLS) | 连不上 Maven Central | 已通过国内镜像 + 宽松 TLS 参数解决 |
| `Unsupported class file major version 65` | Gradle 7.6.3 误用了 JDK 21 | 已在 `gradle.properties` 强制 `org.gradle.java.home=…\jdk-17` |
| `sensors_plus build.gradle.kts Val cannot be reassigned` | sensors_plus 7.x 使用 Kotlin 2.x DSL | 已 `dependency_overrides` 到 6.0.1 |
| `TextureRegistry.SurfaceProducer.Callback 找不到符号` | Flutter 3.22 无该 3.27+ API | 已固定 `wechat_camera_picker: 4.3.7`，连带 camera 回退到 0.10.x |
| `DioException connection failed` 登录连不上后端 | env_dev baseURL 指向祝工电脑 IP `10.105.84.170` | 若其电脑未开机，改 `lib/flavors.dart` `env_dev` 的 `baseURL` 到可用服务地址即可 |

---

## 获取帮助

- Flutter 官方文档：<https://docs.flutter.dev/>
- Dart 文档：<https://dart.dev/guides>
- Android Gradle Plugin 兼容性：<https://developer.android.com/build/releases/gradle-plugin>
