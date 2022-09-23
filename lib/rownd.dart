import 'rownd_platform_interface.dart';
import 'state/global_state.dart';

class RowndPlugin {
  void configure(String appKey, [String? apiUrl, String? baseUrl]) {
    RowndPlatform.instance.configure(appKey, apiUrl, baseUrl);
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

  void manageAccount() {
    RowndPlatform.instance.manageAccount();
  }
}
