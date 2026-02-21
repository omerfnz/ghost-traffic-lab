package com.ghosttraffic.ghost_traffic_lab.engine.humanlike

import java.util.Random

class GaussianDelay(private val seed: Long? = null) {
    private val random = if (seed != null) Random(seed) else Random()

    fun nextDelay(): Long {
        val raw = MEAN + random.nextGaussian() * STD_DEV
        return raw.toLong().coerceIn(MIN_DELAY, MAX_DELAY)
    }

    companion object {
        private const val MEAN = 3000.0
        private const val STD_DEV = 800.0
        private const val MIN_DELAY = 1000L
        private const val MAX_DELAY = 7000L
    }
}
