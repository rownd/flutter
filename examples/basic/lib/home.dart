import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

class HomeScreen extends StatelessWidget {
  final String platformVersion;
  const HomeScreen({super.key, required this.platformVersion});

  @override
  Widget build(BuildContext context) {
    var rowndPlugin = Provider.of<RowndPlugin>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Consumer<GlobalStateNotifier>(builder: (_, rownd, __) {
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
          ElevatedButton(
              onPressed: () {
                var rowndPlugin =
                    Provider.of<RowndPlugin>(context, listen: false);
                () async {
                  var token = await rowndPlugin.getAccessToken();
                  print('Access token: $token');
                }();
              },
              child: const Text('Get token')),
          ElevatedButton(
              onPressed: () {
                var rowndPlugin =
                    Provider.of<RowndPlugin>(context, listen: false);
                rowndPlugin.manageAccount();
              },
              child: const Text('Manage account')),
          ElevatedButton(
              onPressed: () {
                var rowndPlugin =
                    Provider.of<RowndPlugin>(context, listen: false);
                var uuid = UniqueKey().toString();
                rowndPlugin.user.setValue('first_name', uuid);
              },
              child: const Text('Set user value')),
          Text(rownd.state.user?.data?['first_name'] ?? 'No value set'),
          ElevatedButton(
              onPressed: () async {
                var rowndPlugin =
                    Provider.of<RowndPlugin>(context, listen: false);
                var user = await rowndPlugin.user.get();
                if (user != null) {
                  var uuid = UniqueKey().toString();
                  user.data?['last_name'] = uuid;
                  rowndPlugin.user.set(user);
                }
              },
              child: const Text('Update entire user object')),
          Text(rownd.state.user?.data?['last_name'] ?? 'No value set'),
          ElevatedButton(
              onPressed: () async {
                var rowndPlugin =
                    Provider.of<RowndPlugin>(context, listen: false);
                var user = await rowndPlugin.user.get();
                print('User: ${user?.toJson()}');
              },
              child: const Text('Print user')),
        ]);
      }),
    );
  }
}
