package com.ghosttraffic.ghost_traffic_lab

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import com.ghosttraffic.ghost_traffic_lab.services.LogBroadcaster

class MainActivity : FlutterActivity() {
    companion object {
        private const val CONTROL_CHANNEL = "com.ghosttraffic.lab/control"
        private const val LOG_CHANNEL = "com.ghosttraffic.lab/logs"
    }

    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)
        setupControlChannel(engine)
        setupLogChannel(engine)
    }

    private fun setupControlChannel(engine: FlutterEngine) {
        MethodChannel(
            engine.dartExecutor.binaryMessenger,
            CONTROL_CHANNEL,
        ).setMethodCallHandler(MethodCallDispatcher(this))
    }

    private fun setupLogChannel(engine: FlutterEngine) {
        EventChannel(
            engine.dartExecutor.binaryMessenger,
            LOG_CHANNEL,
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(args: Any?, sink: EventChannel.EventSink?) {
                LogBroadcaster.setListener { message ->
                    runOnUiThread { sink?.success(message) }
                }
            }

            override fun onCancel(args: Any?) {
                LogBroadcaster.setListener(null)
            }
        })
    }
}
