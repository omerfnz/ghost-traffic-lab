package com.ghosttraffic.ghost_traffic_lab.services

import android.accessibilityservice.GestureDescription
import android.graphics.Path

object GestureExecutor {
    private const val CLICK_DURATION = 100L
    private const val SWIPE_DURATION = 300L

    fun createClickGesture(x: Float, y: Float): GestureDescription {
        val path = Path().apply { moveTo(x, y) }
        val stroke = GestureDescription.StrokeDescription(
            path, 0L, CLICK_DURATION,
        )
        return GestureDescription.Builder()
            .addStroke(stroke)
            .build()
    }

    fun createLongPressGesture(
        x: Float,
        y: Float,
        duration: Long,
    ): GestureDescription {
        val path = Path().apply { moveTo(x, y) }
        val stroke = GestureDescription.StrokeDescription(
            path, 0L, duration,
        )
        return GestureDescription.Builder()
            .addStroke(stroke)
            .build()
    }

    fun createSwipeGesture(
        startX: Float,
        startY: Float,
        endX: Float,
        endY: Float,
    ): GestureDescription {
        val path = Path().apply {
            moveTo(startX, startY)
            lineTo(endX, endY)
        }
        val stroke = GestureDescription.StrokeDescription(
            path, 0L, SWIPE_DURATION,
        )
        return GestureDescription.Builder()
            .addStroke(stroke)
            .build()
    }

    fun directionToCoordinates(
        direction: String,
    ): FloatArray {
        val centerX = 540f
        val centerY = 960f
        val distance = 500f
        return when (direction.lowercase()) {
            "up" -> floatArrayOf(centerX, centerY, centerX, centerY - distance)
            "down" -> floatArrayOf(centerX, centerY, centerX, centerY + distance)
            "left" -> floatArrayOf(centerX, centerY, centerX - distance, centerY)
            "right" -> floatArrayOf(centerX, centerY, centerX + distance, centerY)
            else -> floatArrayOf(centerX, centerY, centerX, centerY - distance)
        }
    }
}
