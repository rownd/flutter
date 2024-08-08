import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';

import 'home.dart';
import 'splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final RowndPlugin rowndPlugin = RowndPlugin();

  MyApp({super.key}) {
    WidgetsFlutterBinding.ensureInitialized();
    rowndPlugin.configure(RowndConfig(appKey: 'YOUR_APP_KEY'));
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await widget.rowndPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => widget.rowndPlugin.state()),
          Provider(create: (context) => widget.rowndPlugin)
        ],
        child: MaterialApp(
          themeMode: ThemeMode.system,
          darkTheme: ThemeData(brightness: Brightness.dark),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/home': (context) => HomeScreen(platformVersion: _platformVersion),
          },
        ));
  }
}
