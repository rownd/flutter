import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
  void configure(String appKey) {
    methodChannel.invokeMethod('configure', {"appKey": appKey});
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

  @override
  signOut() {
    methodChannel.invokeMethod('signOut');
  }

  @override
  GlobalStateNotifier state() {
    return eventChannel.stateNotifier;
  }

  // @override
  // state() {
  //   return eventChannel
  // }
}
