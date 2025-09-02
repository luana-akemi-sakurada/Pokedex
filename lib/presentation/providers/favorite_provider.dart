import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<int> _favoritePokemonIds = [];

  List<int> get favoritePokemonIds => _favoritePokemonIds;

  bool isFavorite(int pokemonId) {
    return _favoritePokemonIds.contains(pokemonId);
  }

  void toggleFavorite(int pokemonId) {
    if (isFavorite(pokemonId)) {
      _favoritePokemonIds.remove(pokemonId);
    } else {
      _favoritePokemonIds.add(pokemonId);
    }
    notifyListeners();
  }
}