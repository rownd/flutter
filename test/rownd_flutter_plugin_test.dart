import 'package:flutter_test/flutter_test.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:rownd_flutter_plugin/rownd_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

class MockRowndFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements RowndPlugin {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void configure(String appKey, [String? apiUrl, String? baseUrl]) {
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
  GlobalStateNotifier state() {
    // TODO: implement state
    throw UnimplementedError();
  }
}

void main() {
  final RowndPlatform initialPlatform = RowndPlatform.instance;

  test('$MethodChannelRownd is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRownd>());
  });

  test('getPlatformVersion', () async {
    RowndPlugin rowndFlutterPlugin = RowndPlugin();
    MockRowndFlutterPluginPlatform fakePlatform =
        MockRowndFlutterPluginPlatform();
    RowndPlatform.instance = fakePlatform as RowndPlatform;

    expect(await rowndFlutterPlugin.getPlatformVersion(), '42');
  });
}
