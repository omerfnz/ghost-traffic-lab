package com.ghosttraffic.ghost_traffic_lab.services

import android.app.Activity
import android.app.KeyguardManager
import android.content.Context
import android.os.Build
import android.os.PowerManager
import android.view.WindowManager

class DeviceWaker(private val context: Context) {
    private var wakeLock: PowerManager.WakeLock? = null

    fun acquireWakeLock() {
        val pm = context.getSystemService(
            Context.POWER_SERVICE,
        ) as PowerManager

        @Suppress("DEPRECATION")
        wakeLock = pm.newWakeLock(
            PowerManager.FULL_WAKE_LOCK
                or PowerManager.ACQUIRE_CAUSES_WAKEUP
                or PowerManager.ON_AFTER_RELEASE,
            "ghosttraffic:wakelock",
        ).apply {
            acquire(10 * 60 * 1000L)
        }
    }

    fun releaseWakeLock() {
        wakeLock?.let { if (it.isHeld) it.release() }
        wakeLock = null
    }

    fun dismissKeyguard(activity: Activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val km = context.getSystemService(
                Context.KEYGUARD_SERVICE,
            ) as KeyguardManager
            km.requestDismissKeyguard(activity, null)
        } else {
            dismissKeyguardLegacy(activity)
        }
    }

    @Suppress("DEPRECATION")
    private fun dismissKeyguardLegacy(activity: Activity) {
        activity.window.addFlags(
            WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
                or WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
        )
    }

    fun isScreenOn(): Boolean {
        val pm = context.getSystemService(
            Context.POWER_SERVICE,
        ) as PowerManager
        return pm.isInteractive
    }
}
