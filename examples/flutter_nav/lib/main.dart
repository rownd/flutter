import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nav/user.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_auth_cubit.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String _platformVersion = 'Unknown';
  final rowndPlugin = RowndPlugin();

  @override
  void initState() {
    super.initState();
    rowndPlugin.configure(RowndConfig(appKey: 'YOUR_APP_KEY'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RowndAuthCubit(rowndPlugin),
      child: MaterialApp(
        title: 'Example App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: BlocListener<RowndAuthCubit, AuthState>(
          listener: (context, state) {
            if (state == AuthState.authenticated) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: BlocBuilder<RowndAuthCubit, AuthState>(
            builder: (context, state) {
              if (state == AuthState.authenticated) {
                return const MyHomePage();
              } else {
                return const LoginPage();
              }
            },
          ),
        ),
        routes: {
          '/home': (context) => const MyHomePage(),
        },
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = context.read<RowndAuthCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My example app'),
      ),
      body: Column(children: [
        const Center(child: Text('Welcome to my example app!')),
        ElevatedButton(
            onPressed: () async {
              authCubit.signIn();
            },
            child: const Text('Sign in')),
      ]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var authCubit = context.read<RowndAuthCubit>();
    var user = User.fromJson(authCubit.user);

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My example app'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Column(children: [
          Center(child: Text('Welcome to my home page ${user.firstName}!')),
          ElevatedButton(
              onPressed: () async {
                authCubit.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text("Sign out")),
        ]),
      );
    });
  }
}
