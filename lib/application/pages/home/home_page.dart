import 'package:camisetle/application/pages/game/game_page.dart';
import 'package:camisetle/application/pages/previous_challenges/previous_challenges.dart';
import 'package:camisetle/data/jersey_loader.dart';
import 'package:camisetle/data/models/jersey_challange.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    Future<JerseyChallenge?> getTodayChallenge() async {
      final challenges = await loadJerseyChallenges();
      final today = DateTime.now();

      try {
        return challenges.firstWhere((c) => isSameDay(c.date, today));
      } catch (_) {
        return null;
      }
    }

    void showGamePage() async {
      final todayChallenge = await getTodayChallenge();

      if (!mounted) return;

      if (todayChallenge != null) {
        ///Obtiene el numero del challenge actual (El #1 es el 26/6/2025)
        final baseDate = DateTime(2025, 6, 26);
        final today = DateTime.now();

        final difference = today.difference(baseDate).inDays;
        int challengeNumber = difference + 1;

        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GamePage(
              jerseyChallenge: todayChallenge,
              challengeNumber: challengeNumber,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text("No hay desafío para hoy.")));
      }
    }

    return Container(
      color: Colors.lightGreen,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: showGamePage,
            child: Text("Daily challange"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AllChallengesPage(),
                ),
              );
            },
            child: Text("All challenges"),
          ),
        ],
      ),
    );
  }
}
