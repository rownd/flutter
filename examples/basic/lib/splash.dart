import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/state/global_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStateNotifier>(
      builder: (_, rownd, __) {
        if (rownd.state.auth?.isAuthenticated ?? false) {
          Future.delayed(Duration.zero, () {
            Navigator.of(context).pushReplacementNamed('/home');
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Welcome to the app'),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                final rowndPlugin =
                    Provider.of<RowndPlugin>(context, listen: false);
                rowndPlugin.requestSignIn();
              },
              child: const Text('Sign in'),
            ),
          ),
        );
      },
    );
  }
}
