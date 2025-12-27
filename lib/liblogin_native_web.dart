import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'liblogin_native_platform_interface.dart';

/// A web implementation of the LibloginNativePlatform of the LibloginNative plugin.
class LibloginNativeWeb extends LibloginNativePlatform {
  /// Constructs a LibloginNativeWeb
  LibloginNativeWeb();

  static void registerWith(Registrar registrar) {
    LibloginNativePlatform.instance = LibloginNativeWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }

  @override
  Future<String?> getPlatformInfo() async {
    return 'Web';
  }

  Function(String)? _authRedirectHandler;

  @override
  Future<void> setAuthRedirectHandler(Function(String) handler) async {
    _authRedirectHandler = handler;
    _checkInitialUrl();
  }

  void _checkInitialUrl() {
    final uri = Uri.parse(web.window.location.href);
    final code = uri.queryParameters['code'];
    final state = uri.queryParameters['state'];

    if (code != null && state != null) {
      _authRedirectHandler?.call(uri.toString());
      _clearUrlParameters(uri);
    }
  }

  void _clearUrlParameters(Uri uri) {
    final Map<String, String> params = Map.from(uri.queryParameters);
    params.remove('code');
    params.remove('state');
    final newUri = uri.replace(queryParameters: params);
    web.window.history.replaceState(null, '', newUri.toString());
  }
}
