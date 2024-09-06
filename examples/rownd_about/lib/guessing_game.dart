import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rownd_flutter_plugin/rownd_cubit.dart';

import 'leaderboard_page.dart';

class GuessingGame extends StatefulWidget {
  const GuessingGame({super.key});

  @override
  State<GuessingGame> createState() => _GuessingGameState();
}

class _GuessingGameState extends State<GuessingGame> {
  final TextEditingController _controller = TextEditingController();
  int _targetNumber = Random().nextInt(10) + 1;
  String _feedback = '';
  late Timer _timer;
  int _milliseconds = 0;
  bool _isRunning = false;

  void _resetGame() {
    _resetStopwatch();
    setState(() {
      _controller.clear();
      _feedback = '';
      _targetNumber = Random().nextInt(10) + 1;
    });
  }

  String _formatTime(int milliseconds) {
    int seconds = milliseconds ~/ 1000;
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    int hundredths = (milliseconds % 1000) ~/ 10;

    return '$minutes:${seconds.toString().padLeft(2, '0')}.${hundredths.toString().padLeft(2, '0')}';
  }

  void _startStopwatch() {
    if (!_isRunning) {
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          _milliseconds += 100;
        });
      });
      _isRunning = true;
    }
  }

  void _stopStopwatch() {
    if (_isRunning) {
      _timer.cancel();
      _isRunning = false;
    }
  }

  void _resetStopwatch() {
    _stopStopwatch();
    setState(() {
      _milliseconds = 0;
    });
  }

  void _checkGuess() {
    setState(() {
      int guess = int.tryParse(_controller.text) ?? 0;

      if (guess < _targetNumber) {
        _feedback = 'Too low!';
      } else if (guess > _targetNumber) {
        _feedback = 'Too high!';
      } else {
        _feedback = 'Correct!';
        _showCorrectDialog();
        _stopStopwatch();
      }
    });
  }

  void _showCorrectDialog() {
    var authCubit = context.read<RowndCubit>();

    if (authCubit.isAuthenticated()) {
      setState(() {
        final time = _formatTime(_milliseconds);
        final leaderboardState =
            context.findAncestorStateOfType<LeaderboardPageState>();
        if (leaderboardState != null) {
          leaderboardState.addScore(time);
        }
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You guessed the correct number in ${_formatTime(_milliseconds)}.',
              ),
              const SizedBox(height: 20),
              if (!authCubit.isAuthenticated())
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Please ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'sign in',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pop();
                            authCubit.signIn();
                            _resetGame();
                          },
                      ),
                      const TextSpan(text: ' to view the leaderboard.'),
                    ],
                  ),
                ),
            ],
          ),
          actions: <Widget>[
            if (authCubit.isAuthenticated())
              TextButton(
                onPressed: () {
                  final time = _formatTime(_milliseconds);
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(
                    '/leaderboard',
                    arguments: time,
                  );
                  _resetGame();
                },
                child: const Text('View Leaderboard'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            _formatTime(_milliseconds),
            style: const TextStyle(fontSize: 48.0),
          ),
          const SizedBox(height: 20),
          Text(
            'Guess a number between 1-10',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your guess',
            ),
            onSubmitted: (_) => _checkGuess(),
            enabled: _isRunning,
          ),
          const SizedBox(height: 20),
          Text(
            _feedback,
            style: TextStyle(
              fontSize: 24,
              color: _feedback == 'Correct!' ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 10),
          _isRunning
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _resetGame,
                      child: const Text('Reset'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _checkGuess,
                      child: const Text('Submit Guess'),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: _startStopwatch,
                  child: const Text('Start'),
                ),
        ],
      ),
    );
  }
}
