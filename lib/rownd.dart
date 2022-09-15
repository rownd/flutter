import 'rownd_platform_interface.dart';

class RowndPlugin {
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
