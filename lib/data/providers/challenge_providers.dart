import 'package:camisetle/data/models/jersey_challange.dart';
import 'package:camisetle/data/repositories/challenge_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider para el challenge_repository donde se obtienen los datos
final challengesRepositoryProvider = Provider((ref) => ChallengeRepository());

//Provider para obtener el challenge del día actual
final todayChallengeProvider = FutureProvider<JerseyChallenge?>((ref) {
  final todayChallenge = ref
      .watch(challengesRepositoryProvider)
      .getTodayChallenge();
  return todayChallenge;
});

final allChallengesProvider = FutureProvider<List<JerseyChallenge>>((ref) {
  final allChallenges = ref
      .watch(challengesRepositoryProvider)
      .fetchAllChallenges();
  return allChallenges;
});
