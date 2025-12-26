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

    companion object {
        private var loginChannel: MethodChannel? = null // Changed to loginChannel

        fun dispatchRedirect(url: String) {
            Log.d("LibloginNativePlugin", "Dispatching redirect with URL: $url")
            loginChannel?.invokeMethod( // Changed to loginChannel
                "handleAuthRedirect",
                mapOf("url" to url)
            )
        }
    }

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
        // LibloginNativePlugin.channel = channel // Removed this line

        loginChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "me.gurupras.liblogin")
        loginChannel.setMethodCallHandler(loginHandler)
        LibloginNativePlugin.loginChannel = loginChannel // Assigned loginChannel here
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        // LibloginNativePlugin.channel = null // Removed this line
        loginChannel.setMethodCallHandler(null)
        LibloginNativePlugin.loginChannel = null // Assigned loginChannel here
    }
}
