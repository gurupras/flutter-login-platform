import 'package:flutter_test/flutter_test.dart';
import 'package:liblogin_native/liblogin_native.dart';
import 'package:liblogin_native/liblogin_native_platform_interface.dart';
import 'package:liblogin_native/liblogin_native_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLibloginNativePlatform
    with MockPlatformInterfaceMixin
    implements LibloginNativePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getPlatformInfo() => Future.value('Mocked platform info');
}

void main() {
  final LibloginNativePlatform initialPlatform = LibloginNativePlatform.instance;

  test('$MethodChannelLibloginNative is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLibloginNative>());
  });

  test('getPlatformVersion', () async {
    LibloginNative libloginNativePlugin = LibloginNative();
    MockLibloginNativePlatform fakePlatform = MockLibloginNativePlatform();
    LibloginNativePlatform.instance = fakePlatform;

    expect(await libloginNativePlugin.getPlatformVersion(), '42');
  });

  test('getPlatformInfo', () async {
    LibloginNative libloginNativePlugin = LibloginNative();
    MockLibloginNativePlatform fakePlatform = MockLibloginNativePlatform();
    LibloginNativePlatform.instance = fakePlatform;

    expect(await libloginNativePlugin.getPlatformInfo(), 'Mocked platform info');
  });
}
