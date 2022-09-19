import 'rownd_platform_interface.dart';
import 'state/global_state.dart';

class RowndPlugin {
  void configure(String appKey) {
    RowndPlatform.instance.configure(appKey);
  }

  GlobalStateNotifier state() {
    return RowndPlatform.instance.state();
  }

  Future<String?> getPlatformVersion() {
    return RowndPlatform.instance.getPlatformVersion();
  }

  void requestSignIn([RowndSignInOptions? signInOpts]) {
    RowndPlatform.instance.requestSignIn(signInOpts);
  }

  void signOut() {
    RowndPlatform.instance.signOut();
  }
}
