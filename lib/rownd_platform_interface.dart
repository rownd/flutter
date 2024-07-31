import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'web/rownd_method_channel.dart';
import 'mobile/rownd_method_channel.dart';

import 'state/global_state.dart';

abstract class RowndPlatform extends PlatformInterface {
  /// Constructs a RowndPlatform.
  RowndPlatform() : super(token: _token);

  static final Object _token = Object();

  static RowndPlatform _instance = _getDefaultPlatform();

  static RowndPlatform _getDefaultPlatform() {
    if (kIsWeb) {
      return WebMethodChannelRownd();
    } else {
      return MobileMethodChannelRownd();
    }
  }

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

  void configure(RowndConfig configure) {
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

  Auth auth = Auth(Passkeys(
      () => throw UnimplementedError(
          'passkey.register() has not been implemented'),
      () => throw UnimplementedError(
          'passkey.authenticate() has not been implemented')));

  GlobalStateNotifier state() {
    throw UnimplementedError('state() has not been implemented.');
  }
}

class RowndConfig {
  final String appKey;
  final String? apiUrl;
  final String? baseUrl;
  final String? subdomainExtension;
  RowndConfig({required this.appKey, this.apiUrl, this.baseUrl, this.subdomainExtension});
}

class Auth {
  final Passkeys passkeys;
  Auth(this.passkeys);
}

class Passkeys {
  Function _register;
  Function _authenticate;
  Passkeys(this._register, this._authenticate);

  void register() {
    _register();
  }

  void authenticate() {
    _authenticate();
  }
}

class RowndSignInOptions {
  String? postSignInRedirect;
}
