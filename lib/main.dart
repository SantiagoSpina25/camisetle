import 'package:camisetle/application/pages/home/home_page.dart';
import 'package:camisetle/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necesario para que Firebase funcione antes de runApp

  Future<void> importJerseysToFirestore() async {
    final jsonString = await rootBundle.loadString('assets/jerseys.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);

    final firestore = FirebaseFirestore.instance;

    for (var jersey in jsonList) {
      await firestore.collection('jerseys').add({
        'teamName': jersey['teamName'],
        'year': jersey['year'],
        'date': jersey['date'],
        'imageUrl': jersey['imageUrl'],
      });
    }

    print('Camisetas importadas con éxito');
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await importJerseysToFirestore();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1C1C1E),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Camisetle ⚽',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Ajustes',
              onPressed: () {
                //TODO implmentar pagina de ajustes
              },
            ),
          ],
        ),

        body: HomePage(),
      ),
    );
  }
}
