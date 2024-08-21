import 'package:flutter/material.dart';

import 'guessing_game.dart';
import 'options_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showOptions = false;

  void _toggleOptionsPage() {
    setState(() {
      _showOptions = !_showOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    var icon = _showOptions ? const Icon(Icons.close) : const Icon(Icons.menu);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lucky Guess'),
        actions: <Widget>[
          IconButton(
            icon: icon,
            tooltip: 'Show Options',
            onPressed: _toggleOptionsPage,
          ),
        ],
      ),
      body: Center(
        child: _showOptions
            ? OptionsPage(toggleOptions: _toggleOptionsPage)
            : const GuessingGame(),
      ),
    );
  }
}
