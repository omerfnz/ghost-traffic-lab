package com.ghosttraffic.ghost_traffic_lab.scheduling

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.ghosttraffic.ghost_traffic_lab.services.BotService

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val serviceIntent = Intent(context, BotService::class.java).apply {
            putExtra(
                BotService.EXTRA_PAYLOAD,
                intent.getStringExtra(BotService.EXTRA_PAYLOAD),
            )
            putExtra(
                BotService.EXTRA_TARGET_PKG,
                intent.getStringExtra(BotService.EXTRA_TARGET_PKG),
            )
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }
    }
}
