import FlutterMacOS
import AppKit

public class LibloginNativePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "me.gurupras.liblogin", binaryMessenger: registrar.messenger)
    let instance = LibloginNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    case "getPlatformInfo":
      result("Hello from macOS")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
