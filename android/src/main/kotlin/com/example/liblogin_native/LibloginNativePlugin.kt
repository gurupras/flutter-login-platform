package com.example.liblogin_native

import android.util.Log
import androidx.annotation.VisibleForTesting
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** LibloginNativePlugin */
class LibloginNativePlugin : FlutterPlugin {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var loginChannel: MethodChannel

    @VisibleForTesting
    internal val loginHandler =
        MethodCallHandler { call: MethodCall, result: Result ->
            Log.d("LibloginNativePlugin", "onMethodCall: ${call.method}")
            if (call.method == "getPlatformInfo") {
                result.success("Hello from Android")
            } else {
                result.notImplemented()
            }
        }

    @VisibleForTesting
    internal val legacyHandler =
        MethodCallHandler { call, result ->
            if (call.method == "getPlatformVersion") {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            } else {
                result.notImplemented()
            }
        }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "liblogin_native")
        channel.setMethodCallHandler(legacyHandler)

        loginChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "me.gurupras.liblogin")
        loginChannel.setMethodCallHandler(loginHandler)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        loginChannel.setMethodCallHandler(null)
    }
}
