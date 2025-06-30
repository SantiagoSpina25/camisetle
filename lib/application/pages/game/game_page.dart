import 'package:camisetle/data/models/jersey_challange.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.jerseyChallenge,
    required this.challengeNumber,
  });

  final JerseyChallenge jerseyChallenge;
  final int challengeNumber;

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
    int challangeNumber = widget.challengeNumber;

    return Scaffold(
      appBar: AppBar(
        title: Text("Daily challange #$challangeNumber"),
        centerTitle: true,
      ),
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

            ElevatedButton(onPressed: checkAnswer, child: Text("Guess")),
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

  void checkAnswer() {
    final guess = _guessController.text.trim();
    String jerseyTeam = widget.jerseyChallenge.teamName;
    int jerseyYear = widget.jerseyChallenge.year;
    String jerseyRealYear = "$jerseyYear-${jerseyYear + 1}";

    bool isCorrect = guess == jerseyTeam;

    if (isCorrect) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Correct! ✅", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Congratulations, you guessed the right team",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Image.asset(widget.jerseyChallenge.imagePath, height: 150),
              SizedBox(height: 16),
              Text("Team: $jerseyTeam\nYear: $jerseyRealYear"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Ok"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Respuesta incorrecta. ¡Intenta de nuevo!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
    _guessController.clear();
  }
}
