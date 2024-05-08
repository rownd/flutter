import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rownd_flutter_plugin/mobile/rownd_method_channel.dart';

void main() {
  MobileMethodChannelRownd platform = MobileMethodChannelRownd();
  const MethodChannel channel = MethodChannel('rownd_flutter_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
