package com.ghosttraffic.ghost_traffic_lab.engine.humanlike

import java.util.Random

class MicroTremor(private val seed: Long? = null) {
    private val random = if (seed != null) Random(seed) else Random()

    fun applyTremor(x: Float, y: Float): Pair<Float, Float> {
        val offsetX = randomTremorOffset()
        val offsetY = randomTremorOffset()
        return Pair(x + offsetX, y + offsetY)
    }

    val preClickDelay: Long
        get() = (MIN_PRE_DELAY + random.nextInt(DELAY_RANGE)).toLong()

    private fun randomTremorOffset(): Float {
        return (random.nextFloat() - 0.5f) * 2 * MAX_PIXEL_OFFSET
    }

    companion object {
        private const val MAX_PIXEL_OFFSET = 8f
        private const val MIN_PRE_DELAY = 50
        private const val DELAY_RANGE = 100
    }
}
