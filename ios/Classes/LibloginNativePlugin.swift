import Flutter
import UIKit

public class LibloginNativePlugin: NSObject, FlutterPlugin {
  private static var loginChannel: FlutterMethodChannel?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let loginChannel = FlutterMethodChannel(name: "me.gurupras.liblogin", binaryMessenger: registrar.messenger())
    let instance = LibloginNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: loginChannel)
    LibloginNativePlugin.loginChannel = loginChannel
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getPlatformInfo":
      result("Hello from iOS")
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    LibloginNativePlugin.dispatchRedirect(url: url)
    return true
  }

  public static func dispatchRedirect(url: URL) {
    loginChannel?.invokeMethod(
      "handleAuthRedirect",
      arguments: ["url": url.absoluteString]
    )
  }
}
