import 'package:camisetle/data/models/jersey_challange.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.jerseyChallenge});

  final JerseyChallenge jerseyChallenge;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController _guessController = TextEditingController();

  final List<String> allTeams = [
    'Real Madrid',
    'Atletico Madrid',
    'FC Barcelona',
    'Manchester United',
    'Manchester City',
    'Juventus',
    'Inter Milan',
    'AC Milan',
    'Chelsea',
    'Arsenal',
  ];

  List<String> filteredTeams = [];

  @override
  void initState() {
    super.initState();
    _guessController.addListener(() {
      _onGuessChanged(_guessController.text);
    });
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  void _onGuessChanged(String value) {
    setState(() {
      if (value.length > 2) {
        filteredTeams = allTeams
            .where((team) => team.toLowerCase().contains(value.toLowerCase()))
            .toList();
      } else {
        filteredTeams = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily challange #1"), centerTitle: true),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _jerseyRevealGrid(),
            _teamsTextField(),
            ...filteredTeams.map(
              (team) => ListTile(
                title: Text(team),
                onTap: () {
                  _guessController.text = team;
                  setState(() {
                    filteredTeams = [];
                  });
                },
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final guess = _guessController.text.trim();
                print('Usuario adivinó: $guess');
              },
              child: Text("Guess"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jerseyRevealGrid() {
    return Image.asset(widget.jerseyChallenge.imagePath, fit: BoxFit.cover);
  }

  Widget _teamsTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: TextField(
        controller: _guessController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Type the team here',
        ),
      ),
    );
  }
}
