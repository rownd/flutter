import 'package:flutter_test/flutter_test.dart';
import 'package:rownd_flutter_plugin/mobile/rownd_method_channel.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

class MockRowndFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements RowndPlugin {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void configure(RowndConfig configure) {
    // TODO: implement configure
  }

  @override
  void manageAccount() {
    // TODO: implement manageAccount
  }

  @override
  void requestSignIn([RowndSignInOptions? signInOpts]) {
    // TODO: implement requestSignIn
  }

  @override
  void signOut() {
    // TODO: implement signOut
  }

  @override
  Auth get auth => Auth(Passkeys(
      () => '',
      () => ''));

  @override
  set auth(Auth _auth) {
    // TODO: implement auth
  }

  @override
  GlobalStateNotifier state() {
    // TODO: implement state
    throw UnimplementedError();
  }
}

void main() {
  final RowndPlatform initialPlatform = RowndPlatform.instance;

  test('$MobileMethodChannelRownd is the default instance', () {
    expect(initialPlatform, isInstanceOf<MobileMethodChannelRownd>());
  });

  test('getPlatformVersion', () async {
    RowndPlugin rowndFlutterPlugin = RowndPlugin();
    MockRowndFlutterPluginPlatform fakePlatform =
        MockRowndFlutterPluginPlatform();
    RowndPlatform.instance = fakePlatform as RowndPlatform;

    expect(await rowndFlutterPlugin.getPlatformVersion(), '42');
  });
}
