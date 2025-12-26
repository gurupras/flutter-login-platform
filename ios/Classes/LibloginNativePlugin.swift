import Flutter
import UIKit

public class LibloginNativePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "liblogin_native", binaryMessenger: registrar.messenger())
    let instance = LibloginNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let loginChannel = FlutterMethodChannel(name: "me.gurupras.liblogin", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: loginChannel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("handle: \(call.method)")
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getPlatformInfo":
      result("Hello from iOS")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
