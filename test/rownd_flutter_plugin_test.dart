import 'package:flutter_test/flutter_test.dart';
import 'package:rownd_flutter_plugin/rownd_flutter_plugin.dart';
import 'package:rownd_flutter_plugin/rownd_flutter_plugin_platform_interface.dart';
import 'package:rownd_flutter_plugin/rownd_flutter_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRowndFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements RowndFlutterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final RowndFlutterPluginPlatform initialPlatform = RowndFlutterPluginPlatform.instance;

  test('$MethodChannelRowndFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRowndFlutterPlugin>());
  });

  test('getPlatformVersion', () async {
    RowndFlutterPlugin rowndFlutterPlugin = RowndFlutterPlugin();
    MockRowndFlutterPluginPlatform fakePlatform = MockRowndFlutterPluginPlatform();
    RowndFlutterPluginPlatform.instance = fakePlatform;

    expect(await rowndFlutterPlugin.getPlatformVersion(), '42');
  });
}
