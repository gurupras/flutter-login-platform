import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return platformInfo;
  }

  @override
  Future<void> setAuthRedirectHandler(Function(String) handler) async {
    _authRedirectHandler = handler;
    // Inform the native side about the channel to use for sending redirects
    await methodChannel.invokeMethod(
        'setAuthRedirectChannel', 'me.gurupras.liblogin');
  }

  @override
  Future<void> dispatchAuthRedirect(String url) async {
    await methodChannel.invokeMethod('dispatchAuthRedirect', url);
  }

  @override
  Future<bool> login(
      {required Uri authUri, required String redirectUri}) async {
    // The redirectUri is not needed for the method channel implementation,
    // as the native side handles the redirect interception.
    if (await canLaunchUrl(authUri)) {
      return await launchUrl(authUri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
