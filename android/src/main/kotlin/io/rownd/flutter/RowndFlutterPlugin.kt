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
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

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
      "getAccessToken" -> {
        CoroutineScope(Dispatchers.IO).launch {
          try {
            val accessToken = Rownd.getAccessToken(throwIfMissing = true)
            withContext(Dispatchers.Main) {
              if (accessToken != null) {
                result.success(accessToken)
              } else {
                result.error("NO_ACCESS_TOKEN", "No access token found", null)
              }
            }
          } catch (e: Exception) {
            withContext(Dispatchers.Main) {
              result.error("GET_ACCESS_TOKEN_ERROR", e.message, null)
            }
          }
        }
      }
      "passkeysRegister" -> Rownd.auth().passkeys().register()
      "passkeysAuthenticate" -> Rownd.auth().passkeys().authenticate()
      "user.get" -> {
        CoroutineScope(Dispatchers.IO).launch {
          try {
            val json = Json { encodeDefaults = true }
            val user = Rownd.user.get()
            val userJson = json.encodeToString(user)
            withContext(Dispatchers.Main) {
              result.success(userJson)
            }
          } catch (e: Exception) {
            withContext(Dispatchers.Main) {
              result.error("GET_USER_ERROR", e.message, null)
            }
          }
        }
      }
      "user.getValue" -> {
        val key = call.argument<String>("key")
        if (key != null) {
          CoroutineScope(Dispatchers.IO).launch {
            try {
              val value = Rownd.user.get<Any>(key)
              withContext(Dispatchers.Main) {
                result.success(value)
              }
            } catch (e: Exception) {
              withContext(Dispatchers.Main) {
                result.error("GET_USER_VALUE_ERROR", e.message, null)
              }
            }
          }
        } else {
          result.error("INVALID_ARGUMENT", "Key is null", null)
        }
      }
      "user.set" -> {
        val userData = call.argument<Map<String, Any>>("user")
        if (userData != null) {
          CoroutineScope(Dispatchers.IO).launch {
            try {
              Rownd.user.set(userData)
              withContext(Dispatchers.Main) {
                result.success(null)
              }
            } catch (e: Exception) {
              withContext(Dispatchers.Main) {
                result.error("SET_USER_ERROR", e.message, null)
              }
            }
          }
        } else {
          result.error("INVALID_ARGUMENT", "User map is null", null)
        }
      }
      "user.setValue" -> {
        val key = call.argument<String>("key")
        val value = call.argument<Any>("value")
        if (key != null && value != null) {
          CoroutineScope(Dispatchers.IO).launch {
            try {
              Rownd.user.set(key, value)
              withContext(Dispatchers.Main) {
                result.success(null)
              }
            } catch (e: Exception) {
              withContext(Dispatchers.Main) {
                result.error("SET_USER_VALUE_ERROR", e.message, null)
              }
            }
          }
        } else {
          result.error("INVALID_ARGUMENT", "Key or value is null", null)
        }
      }
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
