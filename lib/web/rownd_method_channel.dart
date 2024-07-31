import 'package:rownd_flutter_plugin/state/global_state.dart';
import 'package:rownd_flutter_plugin/web/rownd_event_channel.dart';

import '../rownd_platform_interface.dart';

/// An implementation of [RowndPlatform] that...
class WebMethodChannelRownd extends RowndPlatform {
  final webChannel = RowndStateWebEventChannel();

  @override
  Future<String?> getPlatformVersion() async {
    return 'web';
  }

  @override
  void configure(RowndConfig configure) {
    webChannel.configure(configure);
  }

  @override
  requestSignIn([RowndSignInOptions? signInOpts]) {
    Map<String, String>? map = {};
    String? postSignInRedirect = signInOpts?.postSignInRedirect;
    if (postSignInRedirect != null) {
      map['post_login_redirect'] = postSignInRedirect;
    }
    webChannel.invokeMethod(['requestSignIn'], map.isNotEmpty ? map : null);
  }

  @override
  signOut() {
    webChannel.invokeMethod(['signOut']);
  }

  @override
  manageAccount() {
    webChannel.invokeMethod(['user', 'manageAccount']);
  }

  @override
  Auth get auth => Auth(Passkeys(
      () => webChannel.invokeMethod(['auth','passkeys','promptForPasskeyRegistration']),
      () => webChannel.invokeMethod(['auth','passkeys','authenticate'])));

  @override
  GlobalStateNotifier state() {
    return webChannel.stateNotifier;
  }
}
