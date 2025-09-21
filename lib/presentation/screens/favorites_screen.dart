import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../styles/app_styles.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final favoritePokemons = favoriteProvider.favorites;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppStyles.primaryColor,
        elevation: 4.0,
        centerTitle: true,
        title: Text(
          'Favoritos',
          style: GoogleFonts.pressStart2p(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: favoritePokemons.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_outline, size: 100, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  Text(
                    'Sua Pokédex pessoal está vazia.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.9,
              ),
              itemCount: favoritePokemons.length,
              itemBuilder: (context, index) {
                final pokemon = favoritePokemons[index];
                return PokemonCard(
                  pokemon: pokemon,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PokemonDetailScreen(pokemonUrl: pokemon.url),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
