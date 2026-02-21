package com.ghosttraffic.ghost_traffic_lab.services

object LogBroadcaster {
    private var listener: ((String) -> Unit)? = null

    fun setListener(callback: ((String) -> Unit)?) {
        listener = callback
    }

    fun emit(message: String) {
        listener?.invoke(message)
    }
}
