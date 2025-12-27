import 'package:flutter_test/flutter_test.dart';
import 'package:liblogin_native/liblogin_native.dart';
import 'package:liblogin_native/liblogin_native_platform_interface.dart';

class MockLibloginNativePlatform extends LibloginNativePlatform {
  @override
  Future<String?> getPlatformVersion() async => '42';

  @override
  Future<String?> getPlatformInfo() async => 'Mocked platform info';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LibloginNative', () {
    setUp(() {
      LibloginNativePlatform.instance = MockLibloginNativePlatform();
    });

    final libloginNativePlugin = LibloginNative();

    test('getPlatformVersion returns correct version', () async {
      expect(await libloginNativePlugin.getPlatformVersion(), '42');
    });

    test('getPlatformInfo returns correct info', () async {
      expect(await libloginNativePlugin.getPlatformInfo(), 'Mocked platform info');
    });
  });
}
