package com.ghosttraffic.ghost_traffic_lab.engine.humanlike

import android.accessibilityservice.GestureDescription
import android.graphics.Path
import java.util.Random

class BezierGesture(private val seed: Long? = null) {
    private val random = if (seed != null) Random(seed) else Random()

    fun createSwipePath(
        startX: Float,
        startY: Float,
        endX: Float,
        endY: Float,
    ): GestureDescription {
        val path = buildBezierPath(startX, startY, endX, endY)
        val duration = randomDuration()
        val stroke = GestureDescription.StrokeDescription(path, 0L, duration)
        return GestureDescription.Builder().addStroke(stroke).build()
    }

    private fun buildBezierPath(
        sx: Float,
        sy: Float,
        ex: Float,
        ey: Float,
    ): Path {
        val cp1x = sx + (ex - sx) * 0.3f + randomOffset()
        val cp1y = sy + (ey - sy) * 0.1f + randomOffset()
        val cp2x = sx + (ex - sx) * 0.7f + randomOffset()
        val cp2y = sy + (ey - sy) * 0.9f + randomOffset()
        return Path().apply {
            moveTo(sx, sy)
            cubicTo(cp1x, cp1y, cp2x, cp2y, ex, ey)
        }
    }

    private fun randomOffset(): Float {
        return (random.nextFloat() - 0.5f) * MAX_OFFSET * 2
    }

    private fun randomDuration(): Long {
        val base = BASE_DURATION + random.nextGaussian() * DURATION_JITTER
        return base.toLong().coerceIn(MIN_DURATION, MAX_DURATION)
    }

    companion object {
        private const val MAX_OFFSET = 40f
        private const val BASE_DURATION = 350.0
        private const val DURATION_JITTER = 80.0
        private const val MIN_DURATION = 200L
        private const val MAX_DURATION = 600L
    }
}
