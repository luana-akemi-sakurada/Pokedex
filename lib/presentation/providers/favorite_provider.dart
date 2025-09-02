// lib/providers/favorite_provider.dart

import 'package:flutter/material.dart';
// Importe o modelo que você quer armazenar
import '../../data/models/pokemon_list_item_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<PokemonListItemModel> _favorites = [];

  List<PokemonListItemModel> get favorites => _favorites;

  bool isFavorite(String pokemonName) {
    return _favorites.any((pokemon) => pokemon.name == pokemonName);
  }

  void toggleFavorite(PokemonListItemModel pokemon) {
    if (isFavorite(pokemon.name)) {
      _favorites.removeWhere((p) => p.name == pokemon.name);
    } else {
      _favorites.add(pokemon);
    }
    notifyListeners();
  }
}