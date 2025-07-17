import 'package:camisetle/data/models/jersey_challange.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<JerseyChallenge>> fetchAllChallenges() async {
    final snapshot = await _firestore.collection('jerseys').get();

    return snapshot.docs.map((doc) {
      return JerseyChallenge.fromFirestore(doc.data());
    }).toList();
  }

  Future<JerseyChallenge?> getChallengeForDate(DateTime date) async {
    final queryDate = DateTime(date.year, date.month, date.day);

    final snapshot = await _firestore
        .collection('jerseys')
        .where('date', isEqualTo: queryDate)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return JerseyChallenge.fromFirestore(snapshot.docs.first.data());
    } else {
      return null;
    }
  }

  Future<JerseyChallenge?> getTodayChallenge() {
    return getChallengeForDate(DateTime.now());
  }
}
