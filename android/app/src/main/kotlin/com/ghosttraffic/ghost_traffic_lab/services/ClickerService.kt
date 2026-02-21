package com.ghosttraffic.ghost_traffic_lab.services

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo

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
        if (nodes.isNullOrEmpty()) return false
        return nodes.first().performAction(AccessibilityNodeInfo.ACTION_CLICK)
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

    fun openUrl(url: String) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    fun performBack(): Boolean = performGlobalAction(GLOBAL_ACTION_BACK)

    fun performHome(): Boolean = performGlobalAction(GLOBAL_ACTION_HOME)

    fun performLongPress(x: Float, y: Float, dur: Long) =
        dispatchGesture(
            GestureExecutor.createLongPressGesture(x, y, dur), null, null,
        )

    fun typeText(text: String): Boolean {
        val node = rootInActiveWindow
            ?.findFocus(AccessibilityNodeInfo.FOCUS_INPUT) ?: return false
        val args = Bundle().apply {
            putCharSequence(
                AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE,
                text,
            )
        }
        return node.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT, args)
    }

    companion object {
        var instance: ClickerService? = null
            private set
        fun isRunning(): Boolean = instance != null
    }
}
