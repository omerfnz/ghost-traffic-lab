package com.ghosttraffic.ghost_traffic_lab.scheduling

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import com.ghosttraffic.ghost_traffic_lab.services.BotService

class AlarmScheduler(private val context: Context) {
    private val alarmManager: AlarmManager
        get() = context.getSystemService(AlarmManager::class.java)

    fun scheduleExact(
        triggerAtMillis: Long,
        payload: String,
        targetPackage: String,
    ) {
        val intent = createIntent(payload, targetPackage)
        val pending = createPendingIntent(intent)
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            triggerAtMillis,
            pending,
        )
    }

    fun cancel() {
        val intent = Intent(context, AlarmReceiver::class.java)
        val flags = cancelFlags()
        val pending = PendingIntent.getBroadcast(
            context, REQUEST_CODE, intent, flags,
        )
        pending?.let { alarmManager.cancel(it) }
    }

    fun canScheduleExact(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return true
        return alarmManager.canScheduleExactAlarms()
    }

    private fun createIntent(
        payload: String,
        targetPackage: String,
    ): Intent {
        return Intent(context, AlarmReceiver::class.java).apply {
            putExtra(BotService.EXTRA_PAYLOAD, payload)
            putExtra(BotService.EXTRA_TARGET_PKG, targetPackage)
        }
    }

    private fun createPendingIntent(intent: Intent): PendingIntent {
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        return PendingIntent.getBroadcast(
            context, REQUEST_CODE, intent, flags,
        )
    }

    private fun cancelFlags(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_NO_CREATE
        }
    }

    companion object {
        private const val REQUEST_CODE = 1001
    }
}
