import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'liblogin_native_platform_interface.dart';

/// An implementation of [LibloginNativePlatform] that uses method channels.
class MethodChannelLibloginNative extends LibloginNativePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('me.gurupras.liblogin');

  Function(String)? _authRedirectHandler;

  MethodChannelLibloginNative() {
    methodChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'handleAuthRedirect') {
        final String? url = call.arguments['url'];
        if (url != null) {
          _authRedirectHandler?.call(url);
        }
      }
    });
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getPlatformInfo() async {
    final platformInfo =
        await methodChannel.invokeMethod<String>('getPlatformInfo');
    print('Platform info: $platformInfo');
    return platformInfo;
  }

  @override
  Future<void> setAuthRedirectHandler(Function(String) handler) async {
    _authRedirectHandler = handler;
  }
}
