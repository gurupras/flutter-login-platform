package com.example.liblogin_native

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Test
import org.mockito.Mockito

class LibloginNativePluginTest {

    @Test
    fun onMethodCall_getPlatformVersion_returnsExpectedValue() {
        val plugin = LibloginNativePlugin()
        val handler = plugin.legacyHandler
        val call = MethodCall("getPlatformVersion", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        handler.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).success("Android " + android.os.Build.VERSION.RELEASE)
    }

    @Test
    fun onMethodCall_getPlatformInfo_returnsExpectedValue() {
        val plugin = LibloginNativePlugin()
        val handler = plugin.loginHandler
        val call = MethodCall("getPlatformInfo", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        handler.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).success("Hello from Android")
    }
}
