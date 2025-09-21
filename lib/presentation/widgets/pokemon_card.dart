import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/datasources/pokemon_remote_data_source.dart';
import '../../data/models/pokemon_detail_model.dart';
import '../../data/models/pokemon_list_item_model.dart';
import '../styles/app_styles.dart';

class PokemonCard extends StatefulWidget {
  final PokemonListItemModel pokemon;
  final VoidCallback onTap;

  const PokemonCard({super.key, required this.pokemon, required this.onTap});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  Future<PokemonDetailModel>? _detailsFuture;

  @override
  void initState() {
    super.initState();
    // Inicia a busca pelos detalhes para obter o tipo do Pokémon
    _detailsFuture = PokemonRemoteDataSource().fetchPokemonDetails(widget.pokemon.url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonDetailModel>(
      future: _detailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(child: Center(child: CircularProgressIndicator(color: AppStyles.secondaryColor)));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          // Em caso de erro, mostra um card genérico
          return _buildCardContent(
            context,
            'normal', // tipo padrão
            widget.pokemon,
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png', // imagem padrão
          );
        }

        final pokemonDetails = snapshot.data!;
        final primaryType = pokemonDetails.types.first;
        
        return _buildCardContent(
          context,
          primaryType,
          widget.pokemon,
          pokemonDetails.imageUrl,
        );
      },
    );
  }

  Widget _buildCardContent(BuildContext context, String type, PokemonListItemModel pokemon, String imageUrl) {
    final gradient = AppStyles.typeGradients[type] ?? AppStyles.typeGradients['normal']!;
    final capitalizedName = pokemon.name[0].toUpperCase() + pokemon.name.substring(1);
    final pokemonId = pokemon.url.split('/')[6];

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                right: 8,
                child: Text(
                  '#$pokemonId',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline, color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        capitalizedName,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
