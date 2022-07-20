import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static late final String appName;
  static late final String packageName;
  static late final String version;
  static late final String buildNumber;

  static Future<void> initialise() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  static String get appVersion => '$version+$buildNumber';

  static String get summary => '$appName v$appVersion';
}
