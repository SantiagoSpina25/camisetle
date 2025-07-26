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
    final todayChallengeAsync = ref.watch(todayChallengeProvider);

    final baseDate = DateTime(2025, 7, 10);
    final today = DateTime.now();
    final challengeNumber = today.difference(baseDate).inDays + 1;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '👕 Camisetle',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            todayChallengeAsync.when(
              data: (challenge) => ElevatedButton.icon(
                onPressed: challenge == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GamePage(
                              jerseyChallenge: challenge,
                              challengeNumber: challengeNumber,
                            ),
                          ),
                        );
                      },
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  "Jugar desafío diario",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text(
                "Error: $error",
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AllChallengesPage()),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text(
                "Ver desafíos anteriores",
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
