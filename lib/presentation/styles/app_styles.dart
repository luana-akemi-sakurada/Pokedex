import 'package:flutter/material.dart';

class AppStyles {
  // Cores principais
  static const Color primaryColor = Color(0xFFB9554E);
  static const Color secondaryColor = Color(0xFFF95756);

  // Cores por tipo de Pokémon
  static const Map<String, Color> typeColors = {
    'normal': Color(0xFFA8A77A),
    'fire': Color(0xFFEE8130),
    'water': Color(0xFF6390F0),
    'electric': Color(0xFFF7D02C),
    'grass': Color(0xFF7AC74C),
    'ice': Color(0xFF96D9D6),
    'fighting': Color(0xFFC22E28),
    'poison': Color(0xFFA33EA1),
    'ground': Color(0xFFE2BF65),
    'flying': Color(0xFFA98FF3),
    'psychic': Color(0xFFF95587),
    'bug': Color(0xFFA6B91A),
    'rock': Color(0xFFB6A136),
    'ghost': Color(0xFF735797),
    'dragon': Color(0xFF6F35FC),
    'dark': Color(0xFF705746),
    'steel': Color(0xFFB7B7CE),
    'fairy': Color(0xFFD685AD),
  };

  // Gradientes por tipo de Pokémon (usado na tela de lista)
  static const Map<String, List<Color>> typeGradients = {
    'normal': [Color(0xFFa4acaf), Color(0xFF606c88)],
    'fire': [Color(0xFFf09819), Color(0xFFed6234)],
    'water': [Color(0xFF43c6ac), Color(0xFF191654)],
    'electric': [Color(0xFFfff800), Color(0xFFf8e16c)],
    'grass': [Color(0xFFa8e063), Color(0xFF56ab2f)],
    'ice': [Color(0xFFe0eafc), Color(0xFFcfdef3)],
    'fighting': [Color(0xFFeb3349), Color(0xFFf45c43)],
    'poison': [Color(0xFFaa076b), Color(0xFF61045f)],
    'ground': [Color(0xFFba8b02), Color(0xFF181818)],
    'flying': [Color(0xFF83a4d4), Color(0xFFb6fbff)],
    'psychic': [Color(0xFFffafbd), Color(0xFFffc3a0)],
    'bug': [Color(0xFFdce35b), Color(0xFF45b649)],
    'rock': [Color(0xFF8e9eab), Color(0xFFeef2f3)],
    'ghost': [Color(0xFF485563), Color(0xFF29323c)],
    'dragon': [Color(0xFFda22ff), Color(0xFF9733ee)],
    'dark': [Color(0xFF2c3e50), Color(0xFF000000)],
    'steel': [Color(0xFF757f9a), Color(0xFFd7dde8)],
    'fairy': [Color(0xFFf4c4f3), Color(0xFFfc67fa)],
  };
}

