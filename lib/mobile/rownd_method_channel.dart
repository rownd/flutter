import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../rownd_platform_interface.dart';
import 'rownd_event_channel.dart';
import '../state/global_state.dart';

/// An implementation of [RowndPlatform] that uses method channels.
class MobileMethodChannelRownd extends RowndPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rownd_flutter_plugin');
  
  final eventChannel = RowndStateMobileEventChannel();

  MobileMethodChannelRownd() {
    eventChannel.listen();
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  void configure(RowndConfig configure) {
    methodChannel.invokeMethod('configure', {
      "appKey": configure.appKey,
      "apiUrl": configure.apiUrl,
      "baseUrl": configure.baseUrl,
      "subdomainExtension": configure.subdomainExtension
    });
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
  manageAccount() {
    methodChannel.invokeMethod('manageAccount');
  }

  @override
  Auth get auth => Auth(Passkeys(
      () => methodChannel.invokeMethod("passkeysRegister"),
      () => methodChannel.invokeMethod("passkeysAuthenticate")));

  @override
  GlobalStateNotifier state() {
    return eventChannel.stateNotifier;
  }
}
