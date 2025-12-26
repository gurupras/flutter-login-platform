import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liblogin_native/liblogin_native_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelLibloginNative platform = MethodChannelLibloginNative();
  const MethodChannel channel = MethodChannel('liblogin_native');
  const MethodChannel loginChannel = MethodChannel('me.gurupras.liblogin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(loginChannel, (MethodCall methodCall) async {
      if (methodCall.method == 'getPlatformInfo') {
        return 'Mocked platform info';
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(loginChannel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('getPlatformInfo', () async {
    expect(await platform.getPlatformInfo(), 'Mocked platform info');
  });
}
