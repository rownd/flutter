// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rownd_flutter_plugin/rownd.dart';
import 'package:rownd_flutter_plugin/rownd_cubit.dart';
import 'package:rownd_flutter_plugin/rownd_platform_interface.dart';

import 'home_page.dart';
import 'leaderboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final rowndPlugin = RowndPlugin();

  @override
  void initState() {
    super.initState();
    rowndPlugin.configure(RowndConfig(appKey: "key_tm0lnwe170dplzsqqvj5iu1w"));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RowndCubit(rowndPlugin),
      child: MaterialApp(
        title: 'Rownd About',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
        routes: {
          '/home': (context) => const HomePage(),
          '/leaderboard': (context) => const LeaderboardPage(),
        },
      ),
    );
  }
}
