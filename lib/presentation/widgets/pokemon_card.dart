// lib/presentation/widgets/pokemon_card.dart

import 'package:flutter/material.dart';
import '../../data/models/pokemon_list_item_model.dart';
import '../screens/pokemon_detail_screen.dart';

class PokemonCard extends StatelessWidget {
  final PokemonListItemModel pokemon;

  const PokemonCard({super.key, required this.pokemon});
  @override
  Widget build(BuildContext context) {
    final String capitalizedName =
        pokemon.name[0].toUpperCase() + pokemon.name.substring(1);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailScreen(
              pokemonUrl: pokemon.url,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              pokemon.imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8.0),
            Text(
              capitalizedName,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}