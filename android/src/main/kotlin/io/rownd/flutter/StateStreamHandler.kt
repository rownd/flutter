package io.rownd.flutter

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import io.rownd.android.Rownd
import io.rownd.android.models.repos.GlobalState
import kotlinx.coroutines.*
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

class StateStreamHandler : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    private var coroutineScope: Job? = null
    private var uiThreadHandler = Handler(Looper.getMainLooper())

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        startListeningToStateChanges()
    }

    override fun onCancel(arguments: Any?) {
        stopListeningToStateChanges()
        eventSink = null
    }

    private fun startListeningToStateChanges() {
        coroutineScope = CoroutineScope(Dispatchers.IO).launch {
            Rownd.state.collect {

                uiThreadHandler.post{
                    eventSink?.success(Json.encodeToString(GlobalState.serializer(), it))
                }
            }
        }
    }

    private fun stopListeningToStateChanges() {
        coroutineScope?.cancel()
    }
}