package com.ghosttraffic.ghost_traffic_lab.models

import org.json.JSONArray
import org.json.JSONObject

sealed class PayloadAction {
    data class Wait(val duration: Long) : PayloadAction()
    data class Swipe(val direction: String) : PayloadAction()
    data class Click(val nodeText: String) : PayloadAction()
    data class Launch(val packageName: String) : PayloadAction()
    data class TypeText(val text: String) : PayloadAction()
    data class ClickXy(val x: Float, val y: Float) : PayloadAction()
    data class LongPress(
        val x: Float,
        val y: Float,
        val duration: Long,
    ) : PayloadAction()
    data class OpenUrl(val url: String) : PayloadAction()
    data object Back : PayloadAction()
    data object Home : PayloadAction()
    data class ScrollUntil(
        val text: String,
        val maxScrolls: Int,
    ) : PayloadAction()
    data class RandomWait(
        val minMs: Long,
        val maxMs: Long,
    ) : PayloadAction()

    companion object {
        fun fromJsonArray(json: String): List<PayloadAction> {
            val array = JSONArray(json)
            return (0 until array.length()).map { i ->
                fromJsonObject(array.getJSONObject(i))
            }
        }

        private fun fromJsonObject(obj: JSONObject): PayloadAction {
            return when (obj.getString("action")) {
                "wait" -> Wait(obj.getLong("duration"))
                "swipe" -> Swipe(obj.getString("direction"))
                "click" -> Click(obj.getString("node_text"))
                "launch" -> Launch(obj.getString("package_name"))
                "type" -> TypeText(obj.getString("text"))
                "click_xy" -> ClickXy(
                    obj.getDouble("x").toFloat(),
                    obj.getDouble("y").toFloat(),
                )
                "long_press" -> LongPress(
                    obj.getDouble("x").toFloat(),
                    obj.getDouble("y").toFloat(),
                    obj.getLong("duration"),
                )
                "open_url" -> OpenUrl(obj.getString("url"))
                "back" -> Back
                "home" -> Home
                "scroll_until" -> ScrollUntil(
                    obj.getString("text"),
                    obj.optInt("max_scrolls", 10),
                )
                "random_wait" -> RandomWait(
                    obj.getLong("min_ms"),
                    obj.getLong("max_ms"),
                )
                else -> throw IllegalArgumentException(
                    "Unknown action: ${obj.getString("action")}",
                )
            }
        }
    }
}
