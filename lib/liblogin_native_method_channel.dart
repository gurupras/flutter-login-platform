import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'liblogin_native_platform_interface.dart';

/// An implementation of [LibloginNativePlatform] that uses method channels.
class MethodChannelLibloginNative extends LibloginNativePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('liblogin_native');

  @visibleForTesting
  final loginMethodChannel = const MethodChannel('me.gurupras.liblogin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getPlatformInfo() async {
    final platformInfo =
        await loginMethodChannel.invokeMethod<String>('getPlatformInfo');
    print('Platform info: $platformInfo');
    return platformInfo;
  }
}
