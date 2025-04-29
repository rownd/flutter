import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => LeaderboardPageState();
}

class LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> leaderboard = [
    {'username': 'PlayerOne', 'time': '0:04.23'},
    {'username': 'SpeedyGonzalez', 'time': '0:07.45'},
    {'username': 'QuickSilver', 'time': '0:10.67'},
    {'username': 'Flash', 'time': '0:13.89'},
    {'username': 'Deadpool', 'time': '0:15.00'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final passedTime = ModalRoute.of(context)?.settings.arguments as String?;

    if (passedTime != null) {
      addScore(passedTime);
    }
  }

  void addScore(String time) {
    setState(() {
      leaderboard.add({'username': "You", 'time': time});
      leaderboard.sort((a, b) => a['time'].compareTo(b['time']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Center(
        child: ListView.builder(
          itemCount: leaderboard.length,
          itemBuilder: (context, index) {
            final entry = leaderboard[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text((index + 1).toString()),
              ),
              title: Text(entry['username']),
              trailing: Text(entry['time']),
            );
          },
        ),
      ),
    );
  }
}
