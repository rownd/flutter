import 'rownd_platform_interface.dart';
import 'state/domain/user.dart';
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

  Future<String?> getAccessToken() {
    return RowndPlatform.instance.getAccessToken();
  }

  Auth auth = Auth(Passkeys(
      () => RowndPlatform.instance.auth.passkeys.register(),
      () => RowndPlatform.instance.auth.passkeys.authenticate()));

  UserRepo user = UserRepo(
      get: () => RowndPlatform.instance.user.get(),
      set: (User user) => RowndPlatform.instance.user.set(user),
      setValue: (String key, dynamic value) =>
          RowndPlatform.instance.user.setValue(key, value),
      getValue: (String key) => RowndPlatform.instance.user.getValue(key));
}
