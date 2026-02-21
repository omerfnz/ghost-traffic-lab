package com.ghosttraffic.ghost_traffic_lab.engine

import com.ghosttraffic.ghost_traffic_lab.engine.humanlike.SessionFingerprint
import com.ghosttraffic.ghost_traffic_lab.engine.humanlike.SessionProfile
import com.ghosttraffic.ghost_traffic_lab.models.PayloadAction
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class PayloadEngine(private val onLog: (String) -> Unit) {
    private var job: Job? = null
    private lateinit var profile: SessionProfile

    fun execute(actions: List<PayloadAction>, onComplete: () -> Unit = {}) {
        profile = SessionFingerprint.create()
        val executor = ActionExecutor(profile, onLog)
        onLog("[Engine] Session seed: ${profile.seed}")
        job = CoroutineScope(Dispatchers.Main).launch {
            onLog("[Engine] Starting ${actions.size} actions")
            for ((index, action) in actions.withIndex()) {
                onLog("[Engine] Action ${index + 1}/${actions.size}")
                executor.execute(action)
                addHumanDelay()
            }
            onLog("[Engine] All actions completed")
            onComplete()
        }
    }

    fun cancel() {
        job?.cancel()
        job = null
        onLog("[Engine] Cancelled")
    }

    val isRunning: Boolean get() = job?.isActive == true

    private suspend fun addHumanDelay() {
        val ms = profile.delay.nextDelay()
        onLog("[Delay] ${ms}ms")
        delay(ms)
    }
}
