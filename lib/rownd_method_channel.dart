import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'rownd_platform_interface.dart';

/// An implementation of [RowndPlatform] that uses method channels.
class MethodChannelRownd extends RowndPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rownd_flutter_plugin');

  @visibleForTesting
  static const eventChannel = EventChannel('rownd_flutter_plugin_events');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  requestSignIn([RowndSignInOptions? signInOpts]) {
    if (signInOpts != null) {
      methodChannel.invokeMethod('requestSignIn',
          {"postSignInRedirect": signInOpts.postSignInRedirect});
    } else {
      methodChannel.invokeMethod('requestSignIn');
    }
  }

  // EVENTS
  static Stream<int> get getRowndEventStream {
    return eventChannel.receiveBroadcastStream().cast();
  }
}
