
import 'liblogin_native_platform_interface.dart';

class LibloginNative {
  static Future<String?> getPlatformVersion() {
    return LibloginNativePlatform.instance.getPlatformVersion();
  }

  static Future<String?> getPlatformInfo() {
    return LibloginNativePlatform.instance.getPlatformInfo();
  }
}

