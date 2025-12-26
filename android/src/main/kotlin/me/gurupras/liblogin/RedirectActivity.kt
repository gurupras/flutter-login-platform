package me.gurupras.liblogin

import android.app.Activity
import android.os.Bundle

class RedirectActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        intent?.data?.let { uri ->
            LibloginNativePlugin.dispatchRedirect(uri.toString())
        }

        finish()
    }
}
