package com.ghosttraffic.ghost_traffic_lab.engine

import com.ghosttraffic.ghost_traffic_lab.engine.humanlike.SessionFingerprint
import com.ghosttraffic.ghost_traffic_lab.engine.humanlike.SessionProfile
import com.ghosttraffic.ghost_traffic_lab.models.PayloadAction
import com.ghosttraffic.ghost_traffic_lab.services.ClickerService
import com.ghosttraffic.ghost_traffic_lab.services.GestureExecutor
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class PayloadEngine(private val onLog: (String) -> Unit) {
    private var job: Job? = null
    private lateinit var profile: SessionProfile

    fun execute(actions: List<PayloadAction>) {
        profile = SessionFingerprint.create()
        onLog("[Engine] Session seed: ${profile.seed}")
        job = CoroutineScope(Dispatchers.Main).launch {
            onLog("[Engine] Starting ${actions.size} actions")
            for ((index, action) in actions.withIndex()) {
                onLog("[Engine] Action ${index + 1}/${actions.size}")
                executeAction(action)
                addHumanDelay()
            }
            onLog("[Engine] All actions completed")
        }
    }

    fun cancel() {
        job?.cancel()
        job = null
        onLog("[Engine] Execution cancelled")
    }

    val isRunning: Boolean get() = job?.isActive == true

    private suspend fun executeAction(action: PayloadAction) {
        val service = ClickerService.instance ?: run {
            onLog("[Engine] ERROR: ClickerService not active")
            return
        }
        when (action) {
            is PayloadAction.Wait -> handleWait(action)
            is PayloadAction.Click -> handleClick(action, service)
            is PayloadAction.Swipe -> handleSwipe(action, service)
            is PayloadAction.Launch -> handleLaunch(action, service)
            is PayloadAction.TypeText -> handleTypeText(action)
        }
    }

    private suspend fun handleWait(action: PayloadAction.Wait) {
        onLog("[Wait] ${action.duration}ms")
        delay(action.duration)
    }

    private suspend fun handleClick(
        action: PayloadAction.Click,
        service: ClickerService,
    ) {
        val preDelay = profile.tremor.preClickDelay
        onLog("[Click] '${action.nodeText}' (pre-delay: ${preDelay}ms)")
        delay(preDelay)
        service.clickByText(action.nodeText)
    }

    private fun handleSwipe(
        action: PayloadAction.Swipe,
        service: ClickerService,
    ) {
        val coords = GestureExecutor.directionToCoordinates(action.direction)
        val gesture = profile.gesture.createSwipePath(
            coords[0], coords[1], coords[2], coords[3],
        )
        onLog("[Swipe] ${action.direction} (bezier)")
        service.dispatchGesture(gesture, null, null)
    }

    private fun handleLaunch(
        action: PayloadAction.Launch,
        service: ClickerService,
    ) {
        onLog("[Launch] ${action.packageName}")
        service.launchApp(action.packageName)
    }

    private fun handleTypeText(action: PayloadAction.TypeText) {
        onLog("[TypeText] '${action.text}' — not yet implemented")
    }

    private suspend fun addHumanDelay() {
        val delayMs = profile.delay.nextDelay()
        onLog("[Delay] ${delayMs}ms (gaussian)")
        delay(delayMs)
    }
}
