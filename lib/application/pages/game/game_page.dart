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

  List<String> attempts = [];

  List<bool> revealedCells = List.generate(9, (_) => false);

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

  void checkAnswer() {
    final guess = _guessController.text.trim();

    if (guess.isEmpty || attempts.length >= 6) return;

    setState(() {
      attempts.add(guess);
    });

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
              Image.asset(widget.jerseyChallenge.imageUrl, height: 150),
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
      _revealRandomCell();
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

  void _revealRandomCell() {
    /// Logica para revelar una celda aleatoria

    final unrevealedCells = [];

    //Recorre todas las celdas para ver cuales no han sido reveladas
    for (int i = 0; i < revealedCells.length; i++) {
      if (!revealedCells[i]) {
        unrevealedCells.add(i);
      }
    }

    if (unrevealedCells.isNotEmpty) {
      //Selecciona una celda aleatoria de las no reveladas
      final randomIndex = (unrevealedCells..shuffle()).first;

      //Actualiza el estado para revelar la celda seleccionada
      setState(() {
        revealedCells[randomIndex] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int challangeNumber = widget.challengeNumber;

    return Scaffold(
      appBar: AppBar(
        title: Text("Daily challange #$challangeNumber"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _jerseyRevealGrid(),
              _inputRow(),
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
              _attemptsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jerseyRevealGrid() {
    return SizedBox(
      height: 400,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = constraints.maxWidth / 3;
          final cellHeight = 400 / 3;
          final aspectRatio = cellWidth / cellHeight;

          return Stack(
            children: [
              Image.network(
                widget.jerseyChallenge.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 400,
              ),
              Positioned.fill(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    if (revealedCells[index]) return const SizedBox.shrink();
                    return Container(color: Colors.blueGrey[900]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _inputRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _guessController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Type the team here',
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: checkAnswer,
            icon: Icon(Icons.sports_soccer),
            label: Text("GUESS"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attemptsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: List.generate(6, (index) {
          String? attempt = index < attempts.length ? attempts[index] : null;
          return Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            height: 40,
            decoration: BoxDecoration(
              color: attempt != null
                  ? const Color.fromARGB(255, 199, 57, 57)
                  : Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            alignment: Alignment.center,
            child: Text(
              attempt ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }),
      ),
    );
  }
}
