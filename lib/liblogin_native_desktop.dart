import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:liblogin_native/liblogin_native_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';
import 'local_auth_server.dart';

/// The desktop implementation of [LibloginNativePlatform] for Linux and Windows.
class LibloginNativeDesktop extends LibloginNativePlatform {
  final LocalAuthServer _localAuthServer = LocalAuthServer();
  Function(String)? _authRedirectHandler;

  /// Registers this class as the default instance of [LibloginNativePlatform].
  static void registerWith() {
    LibloginNativePlatform.instance = LibloginNativeDesktop();
  }

  @override
  Future<void> setAuthRedirectHandler(Function(String) handler) async {
    _authRedirectHandler = handler;
  }

  @override
  Future<bool> login(
      {required Uri authUri, required String redirectUri}) async {
    try {
      if (_authRedirectHandler == null) {
        throw Exception(
            'Auth redirect handler not set. Call setAuthRedirectHandler first.');
      }

      final Uri redirect = Uri.parse(redirectUri);
      int port = redirect.port;

      // Start the local server, passing the handler that AuthService gave us.
      await _localAuthServer.start(_authRedirectHandler!, port: port);

      if (await canLaunchUrl(authUri)) {
        await launchUrl(authUri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        await _localAuthServer.stop();
        return false;
      }
    } catch (e) {
      await _localAuthServer.stop();
      debugPrint('Failed to initiate login: $e');
      // Re-throw the exception so the caller (AuthService) can handle it.
      rethrow;
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    // Return a string indicating the platform
    return Platform.operatingSystem;
  }
}
