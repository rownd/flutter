import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'rownd_method_channel.dart';
import 'rownd_event_channel.dart';
import 'state/global_state.dart';

abstract class RowndPlatform extends PlatformInterface {
  /// Constructs a RowndPlatform.
  RowndPlatform() : super(token: _token);

  static final Object _token = Object();

  static RowndPlatform _instance = MethodChannelRownd();
  static final RowndStateEventChannel _stateEventChannel = RowndStateEventChannel();

  /// The default instance of [RowndPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelRowndPlugin].
  static RowndPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RowndPluginPlatform] when
  /// they register themselves.
  static set instance(RowndPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void configure(String appKey, [String? apiUrl, String? baseUrl]) {
    throw UnimplementedError('configure() has not been implemented.');
  }

  void requestSignIn([RowndSignInOptions? signInOpts]) {
    throw UnimplementedError('requestSignIn() has not been implemented.');
  }

  void signOut() {
    throw UnimplementedError('signOut() has not been implemented.');
  }

  void manageAccount() {
    throw UnimplementedError('manageAccount() has not been implemented.');
  }

  GlobalStateNotifier state() {
    throw UnimplementedError('state() has not been implemented.');
  }
}

class RowndSignInOptions {
  String? postSignInRedirect;
}
