import 'dart:convert';
import 'package:camisetle/data/models/jersey_challange.dart';
import 'package:flutter/services.dart';

Future<List<JerseyChallenge>> loadJerseyChallenges() async {
  final jsonString = await rootBundle.loadString('assets/jerseys.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((item) => JerseyChallenge.fromJson(item)).toList();
}
