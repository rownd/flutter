import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

class HomeScreen extends StatelessWidget {
  final String platformVersion;
  const HomeScreen({super.key, required this.platformVersion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Consumer<GlobalStateNotifier>(
        builder: (_, rownd, __) {
          if (rownd.state.auth?.isAuthenticated == false) {
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pushReplacementNamed('/');
            });
        }
          return Column(children: [
          Center(child: Text('Running on: $platformVersion\n')),
          ElevatedButton(
              onPressed: () {
                var rowndPlugin =
                    Provider.of<RowndPlugin>(context, listen: false);
                if (rownd.state.auth?.isAuthenticated ?? false) {
                  rowndPlugin.signOut();
                } else {
                  rowndPlugin.requestSignIn();
                }
              },
              child: const Text('Sign out')),
          if (rownd.state.auth?.isAuthenticated ?? false)
            ElevatedButton(
                onPressed: () {
                  var rowndPlugin =
                      Provider.of<RowndPlugin>(context, listen: false);
                  rowndPlugin.manageAccount();
                },
                child: const Text('Manage account'))
        ]);
        }
      ),
    );
  }
}
