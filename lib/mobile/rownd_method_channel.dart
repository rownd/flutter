import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../rownd_platform_interface.dart';
import '../state/domain/user.dart';
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
  Future<String?> getAccessToken() {
    return methodChannel.invokeMethod<String>('getAccessToken');
  }

  @override
  UserRepo get user => UserRepo(
        get: () => methodChannel.invokeMethod("user.get").then((value) {
          if (value == null) {
            return null;
          }
          if (value is String) {
            return User.fromJson(jsonDecode(value) as Map<String, dynamic>);
          }
          return User.fromJson(value);
        }),
        set: (User user) => methodChannel.invokeMethod("user.set", user.data),
        setValue: (String key, dynamic value) => methodChannel
            .invokeMethod("user.setValue", {"key": key, "value": value}),
        getValue: (String key) =>
            methodChannel.invokeMethod("user.getValue", key),
      );

  @override
  Auth get auth => Auth(Passkeys(
      () => methodChannel.invokeMethod("passkeysRegister"),
      () => methodChannel.invokeMethod("passkeysAuthenticate")));

  @override
  GlobalStateNotifier state() {
    return eventChannel.stateNotifier;
  }
}
