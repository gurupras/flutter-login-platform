import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'liblogin_native_method_channel.dart';

abstract class LibloginNativePlatform extends PlatformInterface {
  /// Constructs a LibloginNativePlatform.
  LibloginNativePlatform() : super(token: _token);

  static final Object _token = Object();

  static LibloginNativePlatform _instance = MethodChannelLibloginNative();

  /// The default instance of [LibloginNativePlatform] to use.
  ///
  /// Defaults to [MethodChannelLibloginNative].
  static LibloginNativePlatform get instance => _instance;
  static set instance(LibloginNativePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getPlatformInfo() {
    throw UnimplementedError('getPlatformInfo() has not been implemented.');
  }
}
