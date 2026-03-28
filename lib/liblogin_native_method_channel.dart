import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'liblogin_native_platform_interface.dart';

/// An implementation of [LibloginNativePlatform] that uses method channels.
class MethodChannelLibloginNative extends LibloginNativePlatform with WidgetsBindingObserver {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('me.gurupras.liblogin');

  Function(String)? _authRedirectHandler;

  MethodChannelLibloginNative() {
    debugPrint('[liblogin_native] MethodChannelLibloginNative() created, setting up handler');
    methodChannel.setMethodCallHandler((MethodCall call) async {
      debugPrint('[liblogin_native] method call received: ${call.method}');
      if (call.method == 'handleAuthRedirect') {
        final String? url = call.arguments['url'];
        debugPrint('[liblogin_native] handleAuthRedirect url=$url, handler set=${_authRedirectHandler != null}');
        if (url != null) {
          _authRedirectHandler?.call(url);
        }
      }
    });
    // Register lifecycle observer so we can poll native for pending redirects on resume.
    // This is the reliable path: Dart→Native (pull) instead of Native→Dart (push).
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPendingRedirect();
    }
  }

  Future<void> _checkPendingRedirect() async {
    try {
      final url = await methodChannel.invokeMethod<String>('getPendingRedirectUrl');
      debugPrint('[liblogin_native] checkPendingRedirect: url=$url');
      if (url != null && _authRedirectHandler != null) {
        _authRedirectHandler!(url);
      }
    } catch (e) {
      debugPrint('[liblogin_native] checkPendingRedirect error: $e');
    }
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
    debugPrint('[liblogin_native] setAuthRedirectHandler called');
    _authRedirectHandler = handler;
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
