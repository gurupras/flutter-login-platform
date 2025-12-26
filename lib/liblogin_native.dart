
import 'liblogin_native_platform_interface.dart';

class LibloginNative {
  Future<String?> getPlatformVersion() {
    return LibloginNativePlatform.instance.getPlatformVersion();
  }

  Future<String?> getPlatformInfo() {
    return LibloginNativePlatform.instance.getPlatformInfo();
  }
}
