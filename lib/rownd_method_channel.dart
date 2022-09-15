import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'rownd_platform_interface.dart';

/// An implementation of [RowndPlatform] that uses method channels.
class MethodChannelRownd extends RowndPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rownd_flutter_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  requestSignIn([RowndSignInOptions? signInOpts]) {
    methodChannel.invokeMethod('requestSignIn', signInOpts);
  }
}
