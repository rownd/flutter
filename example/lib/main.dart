import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _rowndFlutterPlugin = RowndPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();

    _rowndFlutterPlugin.configure("b60bc454-c45f-47a2-8f8a-12b2062f5a77",
        "https://api.us-east-2.dev.rownd.io", "https://hub.rownd.workers.dev");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _rowndFlutterPlugin.getPlatformVersion() ??
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
    return ChangeNotifierProvider(
        create: (_) => _rowndFlutterPlugin.state(),
        child: MaterialApp(
          themeMode: ThemeMode.system,
          darkTheme: ThemeData(brightness: Brightness.dark),
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Plugin example app'),
            ),
            body: Consumer<GlobalStateNotifier>(
              builder: (_, rownd, __) => Column(children: [
                Center(child: Text('Running on: $_platformVersion\n')),
                ElevatedButton(
                    onPressed: () {
                      if (rownd.state.auth?.isAuthenticated ?? false) {
                        _rowndFlutterPlugin.signOut();
                      } else {
                        RowndSignInOptions signInOpts = RowndSignInOptions();
                        signInOpts.postSignInRedirect =
                            "https://www.google.com";
                        _rowndFlutterPlugin.requestSignIn(signInOpts);
                      }
                    },
                    child: Text((rownd.state.auth?.isAuthenticated ?? false)
                        ? 'Sign out'
                        : 'Sign in')),
                if (rownd.state.auth?.isAuthenticated ?? false)
                  ElevatedButton(
                      onPressed: () {
                        _rowndFlutterPlugin.manageAccount();
                      },
                      child: const Text('Manage account'))
              ]),
            ),
          ),
        ));
  }
}
