import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'rownd_platform_interface.dart';
import 'rownd_event_channel.dart';
import 'state/global_state.dart';

/// An implementation of [RowndPlatform] that uses method channels.
class MethodChannelRownd extends RowndPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rownd_flutter_plugin');

  final eventChannel = RowndStateEventChannel();

  MethodChannelRownd() {
    eventChannel.listen();
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  void configure(String appKey, [String? apiUrl, String? baseUrl]) {
    methodChannel.invokeMethod('configure', {
      "appKey": appKey,
      "apiUrl": apiUrl,
      "baseUrl": baseUrl,
    });
  }

  @override
  requestSignIn([RowndSignInOptions? signInOpts]) {
    if (signInOpts != null) {
      final Map<String, String> signInOptionsMap = {};

      final intent = signInOpts.intent;
      if (intent != null) {
        signInOptionsMap['intent'] = RowndSignInIntentStrings[intent]!;
      }
      final postSignInRedirect = signInOpts.postSignInRedirect;
      if (postSignInRedirect != null) {
        signInOptionsMap['postSignInRedirect'] = postSignInRedirect;
      }

      final method = signInOpts.method;
      if (method != null) {
        signInOptionsMap['method'] = RowndSignInMethodStrings[method]!;
      }
      methodChannel.invokeMethod('requestSignIn', signInOptionsMap);
    } else {
      methodChannel.invokeMethod('requestSignIn');
    }
  }

  @override
  signOut() {
    methodChannel.invokeMethod('signOut');
  }

  @override
  manageAccount() {
    methodChannel.invokeMethod('manageAccount');
  }

  @override
  GlobalStateNotifier state() {
    return eventChannel.stateNotifier;
  }
}
