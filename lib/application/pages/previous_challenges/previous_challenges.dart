import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camisetle/data/providers/challenge_providers.dart';
import 'package:camisetle/application/pages/game/game_page.dart';

class AllChallengesPage extends ConsumerWidget {
  const AllChallengesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncChallenges = ref.watch(allChallengesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Challenges"),
        centerTitle: true,
      ),
      body: asyncChallenges.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error")),
        data: (allChallenges) {
          final allChallengesReversed = allChallenges.reversed.toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: allChallengesReversed.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final challenge = allChallengesReversed[index];
                final challengeNumber = allChallengesReversed.length - index;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GamePage(
                          jerseyChallenge: challenge,
                          challengeNumber: challengeNumber,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Center(
                      child: Text(
                        "#$challengeNumber",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
