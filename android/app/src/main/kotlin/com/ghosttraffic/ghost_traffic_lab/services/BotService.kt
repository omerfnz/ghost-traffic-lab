package com.ghosttraffic.ghost_traffic_lab.services

import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import com.ghosttraffic.ghost_traffic_lab.engine.PayloadEngine
import com.ghosttraffic.ghost_traffic_lab.models.PayloadAction

class BotService : Service() {
    private var deviceWaker: DeviceWaker? = null
    private var payloadEngine: PayloadEngine? = null
    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int,
    ): Int {
        LogBroadcaster.clear()
        LogBroadcaster.emit("[Bot] System armed. Starting...")
        startAsForeground()
        deviceWaker = DeviceWaker(this).also { it.acquireWakeLock() }
        setClickerTarget(intent)
        launchTargetApp(intent)
        executePayload(intent)
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        payloadEngine?.cancel()
        deviceWaker?.releaseWakeLock()
        super.onDestroy()
    }

    private fun startAsForeground() {
        NotificationHelper.createChannel(this)
        val notification = NotificationHelper.buildNotification(this)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NotificationHelper.NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
            )
        } else {
            startForeground(
                NotificationHelper.NOTIFICATION_ID,
                notification,
            )
        }
    }

    private fun setClickerTarget(intent: Intent?) {
        val targetPkg = intent?.getStringExtra(EXTRA_TARGET_PKG) ?: return
        ClickerService.instance?.targetPackage = targetPkg
        LogBroadcaster.emit("[Bot] Clicker target: $targetPkg")
    }

    private fun launchTargetApp(intent: Intent?) {
        val targetPkg = intent?.getStringExtra(EXTRA_TARGET_PKG) ?: return
        try {
            val launchIntent = packageManager.getLaunchIntentForPackage(targetPkg)
            if (launchIntent != null) {
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(launchIntent)
            } else {
                LogBroadcaster.emit("[Bot] App not found: $targetPkg")
            }
        } catch (e: Exception) {
            LogBroadcaster.emit("[Bot] Launch error: ${e.message}")
        }
    }

    private fun executePayload(intent: Intent?) {
        val json = intent?.getStringExtra(EXTRA_PAYLOAD) ?: return
        try {
            val actions = PayloadAction.fromJsonArray(json)
            payloadEngine = PayloadEngine { LogBroadcaster.emit(it) }
            payloadEngine?.execute(actions) {
                stopSelf()
            }
        } catch (e: Exception) {
            LogBroadcaster.emit("[Bot] Payload error: ${e.message}")
            stopSelf()
        }
    }

    companion object {
        const val EXTRA_PAYLOAD = "extra_payload"
        const val EXTRA_TARGET_PKG = "extra_target_pkg"

        fun start(context: Context, payload: String, targetPkg: String) {
            val intent = Intent(context, BotService::class.java).apply {
                putExtra(EXTRA_PAYLOAD, payload)
                putExtra(EXTRA_TARGET_PKG, targetPkg)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context) {
            context.stopService(Intent(context, BotService::class.java))
        }

        @Suppress("DEPRECATION")
        fun isRunning(context: Context): Boolean {
            val manager = context.getSystemService(
                Context.ACTIVITY_SERVICE,
            ) as android.app.ActivityManager
            return manager.getRunningServices(Int.MAX_VALUE)
                .any { it.service.className == BotService::class.java.name }
        }
    }
}
