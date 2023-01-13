import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  late RowndPlugin rowndPlugin;

  MyApp({super.key}) {
    WidgetsFlutterBinding.ensureInitialized();
    rowndPlugin = RowndPlugin();
    rowndPlugin.configure("5b445042-7c8e-4c84-b451-e25c608e8bc0",
        "https://api.us-east-2.dev.rownd.io", "https://hub.dev.rownd.io");
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
    return ChangeNotifierProvider(
        create: (_) => widget.rowndPlugin.state(),
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
                        widget.rowndPlugin.signOut();
                      } else {
                        RowndSignInOptions signInOpts = RowndSignInOptions();
                        signInOpts.postSignInRedirect = "NATIVE_APP";
                        widget.rowndPlugin.requestSignIn(signInOpts);
                      }
                    },
                    child: Text((rownd.state.auth?.isAuthenticated ?? false)
                        ? 'Sign out'
                        : 'Sign in')),
                if (rownd.state.auth?.isAuthenticated ?? false)
                  ElevatedButton(
                      onPressed: () {
                        widget.rowndPlugin.manageAccount();
                      },
                      child: const Text('Manage account'))
              ]),
            ),
          ),
        ));
  }
}
