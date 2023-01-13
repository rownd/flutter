package io.rownd.flutter

import android.app.Activity
import android.app.Application
import android.content.Context
import androidx.annotation.NonNull
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.rownd.android.Rownd
import io.rownd.android.RowndSignInOptions

/** RowndFlutterPlugin */
class RowndFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var activity : FragmentActivity
  private val methodChannelName = "rownd_flutter_plugin"
  private val stateEventChannelName = "rownd_channel_events/state"

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannelName)
    channel.setMethodCallHandler(this)

    EventChannel(flutterPluginBinding.binaryMessenger, stateEventChannelName)
      .setStreamHandler(StateStreamHandler())
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "configure" -> {
        val customApiUrl = call.argument<String>("apiUrl")
        val customBaseUrl = call.argument<String>("baseUrl")

        if (customApiUrl != null) {
          Rownd.config.apiUrl = customApiUrl
        }

        if (customBaseUrl != null) {
          Rownd.config.baseUrl = customBaseUrl
        }

        Rownd.configure(this.activity, call.argument<String>("appKey") ?: "")
      }
      "requestSignIn" -> {
        val postSignInRedirect = call.argument<String>("postSignInRedirect")
        if (postSignInRedirect != null) {
          Rownd.requestSignIn(RowndSignInOptions(postSignInRedirect = postSignInRedirect))
        } else {
          Rownd.requestSignIn()
        }
      }
      "signOut" -> Rownd.signOut()
      "manageAccount" -> Rownd.manageAccount()
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity as FragmentActivity
    Rownd._registerActivityLifecycle(activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // no-op
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    // no-op
  }

  override fun onDetachedFromActivity() {
    // no-op
  }
}
