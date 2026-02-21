package com.ghosttraffic.ghost_traffic_lab.engine

import com.ghosttraffic.ghost_traffic_lab.engine.humanlike.SessionProfile
import com.ghosttraffic.ghost_traffic_lab.models.PayloadAction
import com.ghosttraffic.ghost_traffic_lab.services.ClickerService
import com.ghosttraffic.ghost_traffic_lab.services.GestureExecutor
import kotlinx.coroutines.delay

class ActionExecutor(
    private val profile: SessionProfile,
    private val onLog: (String) -> Unit,
) {
    suspend fun execute(action: PayloadAction) {
        when (action) {
            is PayloadAction.Wait -> handleWait(action)
            is PayloadAction.Click -> withService { handleClick(action, it) }
            is PayloadAction.Swipe -> withService { handleSwipe(action, it) }
            is PayloadAction.Launch -> withService { it.launchApp(action.packageName) }
            is PayloadAction.TypeText -> withService { handleTypeText(action, it) }
            is PayloadAction.ClickXy -> withService { handleClickXy(action, it) }
            is PayloadAction.LongPress -> withService { it.performLongPress(action.x, action.y, action.duration) }
            is PayloadAction.OpenUrl -> withService { it.openUrl(action.url) }
            is PayloadAction.Back -> withService { it.performBack() }
            is PayloadAction.Home -> withService { it.performHome() }
            is PayloadAction.ScrollUntil -> withService { handleScrollUntil(action, it) }
            is PayloadAction.RandomWait -> handleRandomWait(action)
        }
    }

    private inline fun withService(block: (ClickerService) -> Unit) {
        val s = ClickerService.instance
        if (s == null) onLog("[Engine] ClickerService not active") else block(s)
    }

    private suspend fun handleWait(a: PayloadAction.Wait) {
        onLog("[Wait] ${a.duration}ms"); delay(a.duration)
    }

    private suspend fun handleClick(a: PayloadAction.Click, s: ClickerService) {
        val pre = profile.tremor.preClickDelay
        onLog("[Click] '${a.nodeText}' (pre: ${pre}ms)")
        delay(pre); s.clickByText(a.nodeText)
    }

    private fun handleSwipe(a: PayloadAction.Swipe, s: ClickerService) {
        val c = GestureExecutor.directionToCoordinates(a.direction)
        val g = profile.gesture.createSwipePath(c[0], c[1], c[2], c[3])
        onLog("[Swipe] ${a.direction}"); s.dispatchGesture(g, null, null)
    }

    private fun handleTypeText(a: PayloadAction.TypeText, s: ClickerService) {
        onLog("[TypeText] '${a.text}'"); s.typeText(a.text)
    }

    private fun handleClickXy(a: PayloadAction.ClickXy, s: ClickerService) {
        val (x, y) = profile.tremor.applyTremor(a.x, a.y)
        onLog("[ClickXY] ($x, $y)"); s.performClick(x, y)
    }

    private suspend fun handleScrollUntil(
        a: PayloadAction.ScrollUntil,
        s: ClickerService,
    ) {
        for (i in 1..a.maxScrolls) {
            if (s.clickByText(a.text)) {
                onLog("[ScrollUntil] Found '${a.text}' at scroll $i")
                return
            }
            onLog("[ScrollUntil] $i/${a.maxScrolls}")
            s.executeSwipe("up")
            delay(profile.delay.nextDelay())
        }
        onLog("[ScrollUntil] '${a.text}' not found")
    }

    private suspend fun handleRandomWait(a: PayloadAction.RandomWait) {
        val range = a.maxMs - a.minMs
        val ms = a.minMs + (Math.random() * range).toLong()
        onLog("[RandomWait] ${ms}ms (${a.minMs}-${a.maxMs})")
        delay(ms)
    }
}
