package me.gurupras.liblogin

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
    private lateinit var methodChannel: MethodChannel

    companion object {
        private var methodChannel: MethodChannel? = null

        fun dispatchRedirect(url: String) {
            Log.d("LibloginNativePlugin", "Dispatching redirect with URL: $url")
            methodChannel?.invokeMethod(
                "handleAuthRedirect",
                mapOf("url" to url)
            )
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "me.gurupras.liblogin")
        methodChannel.setMethodCallHandler { call, result ->
            Log.d("LibloginNativePlugin", "onMethodCall: ${call.method}")
            when (call.method) {
                "getPlatformInfo" -> result.success("Hello from Android")
                "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
                else -> result.notImplemented()
            }
        }
        LibloginNativePlugin.methodChannel = methodChannel
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        LibloginNativePlugin.methodChannel = null
    }
}
