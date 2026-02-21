package com.ghosttraffic.ghost_traffic_lab.models

import org.json.JSONArray
import org.json.JSONObject

sealed class PayloadAction {
    data class Wait(val duration: Long) : PayloadAction()
    data class Swipe(val direction: String) : PayloadAction()
    data class Click(val nodeText: String) : PayloadAction()
    data class Launch(val packageName: String) : PayloadAction()
    data class TypeText(val text: String) : PayloadAction()

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
                else -> throw IllegalArgumentException(
                    "Unknown action: ${obj.getString("action")}"
                )
            }
        }
    }
}
