import 'package:camisetle/application/pages/game/game_page.dart';
import 'package:camisetle/data/jersey_loader.dart';
import 'package:camisetle/data/models/jersey_challange.dart';
import 'package:flutter/material.dart';

class AllChallengesPage extends StatefulWidget {
  const AllChallengesPage({super.key});

  @override
  State<AllChallengesPage> createState() => _AllChallengesPageState();
}

class _AllChallengesPageState extends State<AllChallengesPage> {
  late Future<List<JerseyChallenge>> _futureChallenges;

  @override
  void initState() {
    super.initState();
    _futureChallenges = loadJerseyChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Challenges"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<JerseyChallenge>>(
        future: _futureChallenges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final allChallenges = snapshot.data!;

          final allChallangesRevered = allChallenges.reversed.toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: allChallangesRevered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final challenge = allChallangesRevered[index];
                final challengeNumber = allChallangesRevered.length - index;

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
