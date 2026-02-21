package com.ghosttraffic.ghost_traffic_lab

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import com.ghosttraffic.ghost_traffic_lab.services.ClickerService

object PermissionChecker {
    fun checkAccessibility(): Boolean = ClickerService.isRunning()

    fun checkOverlay(context: Context): Boolean {
        return Settings.canDrawOverlays(context)
    }

    fun checkBatteryOpt(context: Context): Boolean {
        val pm = context.getSystemService(
            Context.POWER_SERVICE,
        ) as PowerManager
        return pm.isIgnoringBatteryOptimizations(
            context.packageName,
        )
    }

    fun checkExactAlarm(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return true
        val am = context.getSystemService(
            android.app.AlarmManager::class.java,
        )
        return am.canScheduleExactAlarms()
    }

    fun requestAccessibility(context: Context) {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    fun requestOverlay(context: Context) {
        val intent = Intent(
            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
            Uri.parse("package:${context.packageName}"),
        )
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    fun requestBatteryOpt(context: Context) {
        @Suppress("BatteryLife")
        val intent = Intent(
            Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
            Uri.parse("package:${context.packageName}"),
        )
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    fun requestExactAlarm(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val intent = Intent(
                Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM,
                Uri.parse("package:${context.packageName}"),
            )
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        }
    }
}
