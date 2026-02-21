package com.ghosttraffic.ghost_traffic_lab.services

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.view.accessibility.AccessibilityEvent

class ClickerService : AccessibilityService() {
    var targetPackage: String? = null

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
        LogBroadcaster.emit("[Clicker] Service connected")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        val evt = event ?: return
        if (evt.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return

        val pkg = evt.packageName?.toString() ?: return
        val target = targetPackage ?: return
        if (pkg != target) return

        LogBroadcaster.emit("[Clicker] Target detected: $pkg")
    }

    override fun onInterrupt() {
        LogBroadcaster.emit("[Clicker] Service interrupted")
    }

    override fun onDestroy() {
        instance = null
        LogBroadcaster.emit("[Clicker] Service destroyed")
        super.onDestroy()
    }

    fun clickByText(text: String): Boolean {
        val root = rootInActiveWindow ?: return false
        val nodes = root.findAccessibilityNodeInfosByText(text)
        if (nodes.isNullOrEmpty()) {
            LogBroadcaster.emit("[Clicker] Node not found: '$text'")
            return false
        }
        return nodes.first().performAction(
            android.view.accessibility.AccessibilityNodeInfo.ACTION_CLICK,
        )
    }

    fun executeSwipe(direction: String) {
        val coords = GestureExecutor.directionToCoordinates(direction)
        val gesture = GestureExecutor.createSwipeGesture(
            coords[0], coords[1], coords[2], coords[3],
        )
        dispatchGesture(gesture, null, null)
    }

    fun performClick(x: Float, y: Float) {
        val gesture = GestureExecutor.createClickGesture(x, y)
        dispatchGesture(gesture, null, null)
    }

    fun launchApp(packageName: String) {
        val intent = packageManager.getLaunchIntentForPackage(packageName)
        if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } else {
            LogBroadcaster.emit("[Clicker] App not found: $packageName")
        }
    }

    companion object {
        var instance: ClickerService? = null
            private set

        fun isRunning(): Boolean = instance != null
    }
}
