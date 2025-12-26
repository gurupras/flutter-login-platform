import Flutter
import UIKit

public class LibloginNativePlugin: NSObject, FlutterPlugin {
  private static var loginChannel: FlutterMethodChannel? // Changed to loginChannel

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "liblogin_native", binaryMessenger: registrar.messenger())
    let instance = LibloginNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    // LibloginNativePlugin.channel = channel // Removed this line

    let loginChannel = FlutterMethodChannel(name: "me.gurupras.liblogin", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: loginChannel)
    LibloginNativePlugin.loginChannel = loginChannel // Assigned loginChannel here
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

  public static func dispatchRedirect(url: URL) {
    loginChannel?.invokeMethod( // Changed to loginChannel
      "handleAuthRedirect",
      arguments: ["url": url.absoluteString]
    )
  }
}
