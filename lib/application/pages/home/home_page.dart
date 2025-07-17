import 'package:camisetle/application/pages/game/game_page.dart';
import 'package:camisetle/application/pages/previous_challenges/previous_challenges.dart';
import 'package:camisetle/data/models/jersey_challange.dart';
import 'package:camisetle/data/providers/challenge_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void showGamePage() async {
      final todayChallenge = ref.watch(todayChallengeProvider);

      final baseDate = DateTime(2025, 7, 10);
      final today = DateTime.now();

      final difference = today.difference(baseDate).inDays;
      int challengeNumber = difference + 1;

      return todayChallenge.when(
        data: (challenge) {
          //Si no hay challenge para hoy, muestra un mensaje
          if (challenge == null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("No hay desafío para hoy.")));
          }

          //Si hay challenge, navega a la página del juego
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GamePage(
                jerseyChallenge: challenge!,
                challengeNumber: challengeNumber,
              ),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error")),
      );
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
