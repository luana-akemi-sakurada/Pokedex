// lib/main.dart

import 'package:flutter/material.dart';
import 'presentation/screens/pokedex_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex Explorer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const PokedexScreen(),
    );
  }
}