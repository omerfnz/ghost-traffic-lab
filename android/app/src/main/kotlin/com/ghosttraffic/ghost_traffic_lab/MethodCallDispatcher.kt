package com.ghosttraffic.ghost_traffic_lab

import android.content.Context
import com.ghosttraffic.ghost_traffic_lab.scheduling.AlarmScheduler
import com.ghosttraffic.ghost_traffic_lab.services.BotService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodCallDispatcher(
    private val context: Context,
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkAccessibility" -> checkPermission(result) {
                PermissionChecker.checkAccessibility()
            }
            "checkOverlay" -> checkPermission(result) {
                PermissionChecker.checkOverlay(context)
            }
            "checkBatteryOpt" -> checkPermission(result) {
                PermissionChecker.checkBatteryOpt(context)
            }
            "checkExactAlarm" -> checkPermission(result) {
                PermissionChecker.checkExactAlarm(context)
            }
            "requestAccessibility" -> requestPerm(result) {
                PermissionChecker.requestAccessibility(context)
            }
            "requestOverlay" -> requestPerm(result) {
                PermissionChecker.requestOverlay(context)
            }
            "requestBatteryOpt" -> requestPerm(result) {
                PermissionChecker.requestBatteryOpt(context)
            }
            "requestExactAlarm" -> requestPerm(result) {
                PermissionChecker.requestExactAlarm(context)
            }
            "startService" -> handleStartService(call, result)
            "stopService" -> handleStopService(result)
            "scheduleAlarm" -> handleScheduleAlarm(call, result)
            "cancelAlarm" -> handleCancelAlarm(result)
            "isServiceRunning" -> result.success(
                BotService.isRunning(context),
            )
            else -> result.notImplemented()
        }
    }

    private fun checkPermission(
        result: MethodChannel.Result,
        check: () -> Boolean,
    ) {
        result.success(check())
    }

    private fun requestPerm(
        result: MethodChannel.Result,
        request: () -> Unit,
    ) {
        request()
        result.success(null)
    }

    private fun handleStartService(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        val payload = call.argument<String>("payload") ?: ""
        val targetPkg = call.argument<String>("targetPackage") ?: ""
        BotService.start(context, payload, targetPkg)
        result.success(null)
    }

    private fun handleStopService(result: MethodChannel.Result) {
        BotService.stop(context)
        result.success(null)
    }

    private fun handleScheduleAlarm(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        val triggerAt = call.argument<Long>("triggerAtMillis") ?: 0L
        val payload = call.argument<String>("payload") ?: ""
        val targetPkg = call.argument<String>("targetPackage") ?: ""
        AlarmScheduler(context).scheduleExact(triggerAt, payload, targetPkg)
        result.success(null)
    }

    private fun handleCancelAlarm(result: MethodChannel.Result) {
        AlarmScheduler(context).cancel()
        result.success(null)
    }
}
