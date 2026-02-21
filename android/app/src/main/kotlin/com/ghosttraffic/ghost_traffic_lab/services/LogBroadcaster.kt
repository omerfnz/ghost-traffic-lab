package com.ghosttraffic.ghost_traffic_lab.services

import android.util.Log

object LogBroadcaster {
    private const val TAG = "GhostTraffic"
    private var listener: ((String) -> Unit)? = null
    private val history = mutableListOf<String>()

    @Synchronized
    fun setListener(callback: ((String) -> Unit)?) {
        listener = callback
        if (callback != null) {
            history.forEach { callback.invoke(it) }
        }
    }

    @Synchronized
    fun emit(message: String) {
        Log.d(TAG, message)
        if (history.size >= 100) history.removeAt(0)
        history.add(message)
        listener?.invoke(message)
    }

    @Synchronized
    fun clear() {
        history.clear()
    }
}
