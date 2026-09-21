enum Flavor {
  env_dev,
  env_release,
  env_release_32,
  env_test,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.env_dev:
        return '客车管理（本地测试）';
      case Flavor.env_release:
        return '客车管理子系统';
      case Flavor.env_release_32:
        return '客车管理子系统';
      case Flavor.env_test:
        return '客车管理子系统（测试）';
    }
  }

  static String get baseURL {
    switch (appFlavor) {
      case Flavor.env_dev:
        // 高
        // return 'http://10.105.84.110:8080';
        // 祝
        return 'http://10.105.84.170:8080';
      case Flavor.env_release:
        return 'https://wkl.wkl.com';
      case Flavor.env_release_32:
        return 'https://wkl.wkl.com';
      case Flavor.env_test:
        return 'http://10.102.81.68:9000/publictest';
    }
  }

}
