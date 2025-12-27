package me.gurupras.liblogin

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log

class RedirectActivity : Activity() {

    companion object {
        private const val TAG = "LibloginRedirect"
        private const val RESUME_ACTION = "me.gurupras.liblogin.AUTH_COMPLETE"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.d(TAG, "RedirectActivity created")

        val uri = intent?.data
        if (uri == null) {
            Log.w(TAG, "No URI found on intent; finishing RedirectActivity")
            finish()
            return
        }

        Log.d(TAG, "Received redirect URI: $uri")

        // Dispatch to Flutter via MethodChannel (hot-path)
        try {
            Log.d(TAG, "Dispatching redirect to Flutter MethodChannel")
            LibloginNativePlugin.dispatchRedirect(uri.toString())
        } catch (t: Throwable) {
            Log.e(TAG, "Failed to dispatch redirect to Flutter", t)
        }

        // Fire custom intent to bring app back to foreground
        val resumeIntent = Intent(RESUME_ACTION).apply {
            addCategory(Intent.CATEGORY_DEFAULT)
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_CLEAR_TOP or
                Intent.FLAG_ACTIVITY_SINGLE_TOP
            )
        }

        Log.d(
            TAG,
            "Firing resume intent " +
                "(action=$RESUME_ACTION, flags=${resumeIntent.flags}, data=$uri)"
        )

        try {
            startActivity(resumeIntent)
            Log.d(TAG, "Resume intent successfully started")
        } catch (t: Throwable) {
            Log.e(TAG, "Failed to start resume intent", t)
        }

        Log.d(TAG, "Finishing RedirectActivity")
        finish()
    }
}
