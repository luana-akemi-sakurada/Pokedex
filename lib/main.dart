// lib/main.dart

import 'package:flutter/material.dart';
import 'presentation/screens/pokedex_screen.dart';
import 'presentation/providers/favorite_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteProvider(), 
      child: MaterialApp(
        title: 'Pokédex Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const PokedexScreen(),
      ),
    );
  }
}