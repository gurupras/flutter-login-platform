
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:liblogin_native/liblogin_native_desktop.dart';
import 'package:liblogin_native/liblogin_native_method_channel.dart';

import 'liblogin_native_platform_interface.dart';

void _ensurePlatformImplementation() {
  // Don't do anything if an implementation has already been registered.
  if (LibloginNativePlatform.instance is! MethodChannelLibloginNative) {
    return;
  }
  // Register the Desktop implementation if we're on Linux or Windows.
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    LibloginNativeDesktop.registerWith();
  }
}

class LibloginNative {
  LibloginNative() {
    _ensurePlatformImplementation();
  }

  Future<String?> getPlatformVersion() {
    return LibloginNativePlatform.instance.getPlatformVersion();
  }

  Future<String?> getPlatformInfo() {
    return LibloginNativePlatform.instance.getPlatformInfo();
  }

  Future<void> setAuthRedirectHandler(Function(String) handler) {
    return LibloginNativePlatform.instance.setAuthRedirectHandler(handler);
  }

  Future<void> dispatchAuthRedirect(String url) {
    return LibloginNativePlatform.instance.dispatchAuthRedirect(url);
  }

  Future<bool> login(
      {required Uri authUri, required String redirectUri}) {
    return LibloginNativePlatform.instance
        .login(authUri: authUri, redirectUri: redirectUri);
  }
}

