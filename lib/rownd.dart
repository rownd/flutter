import 'rownd_platform_interface.dart';
import 'state/global_state.dart';

class RowndPlugin {
  void configure(RowndConfig configure) {
    RowndPlatform.instance.configure(configure);
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

  Auth auth = Auth(Passkeys(
      () => RowndPlatform.instance.auth.passkeys.register(),
      () => RowndPlatform.instance.auth.passkeys.authenticate()));
}
