package com.ghosttraffic.ghost_traffic_lab.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import androidx.core.app.NotificationCompat

object NotificationHelper {
    const val CHANNEL_ID = "ghost_traffic_bot"
    const val NOTIFICATION_ID = 1

    fun createChannel(context: Context) {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "GhostTraffic Bot",
            NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = "Background automation service"
            setShowBadge(false)
        }
        val manager = context.getSystemService(
            NotificationManager::class.java,
        )
        manager.createNotificationChannel(channel)
    }

    fun buildNotification(context: Context): Notification {
        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle("GhostTraffic Active")
            .setContentText("Automation running...")
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }
}
