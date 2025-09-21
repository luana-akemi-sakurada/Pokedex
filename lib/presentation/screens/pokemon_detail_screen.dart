import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/datasources/pokemon_remote_data_source.dart';
import '../../data/models/pokemon_detail_model.dart';
import '../../data/models/pokemon_list_item_model.dart';
import '../providers/favorite_provider.dart';
import '../styles/app_styles.dart';

class PokemonDetailScreen extends StatefulWidget {
  final String pokemonUrl;
  const PokemonDetailScreen({super.key, required this.pokemonUrl});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late Future<PokemonDetailModel> _pokemonDetailFuture;
  final PokemonRemoteDataSource _dataSource = PokemonRemoteDataSource();

  @override
  void initState() {
    super.initState();
    _pokemonDetailFuture = _dataSource.fetchPokemonDetails(widget.pokemonUrl);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonDetailModel>(
      future: _pokemonDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: const Center(
              child: CircularProgressIndicator(color: AppStyles.secondaryColor),
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Erro"),
              backgroundColor: AppStyles.primaryColor,
            ),
            body: Center(
              child: Text(
                  "Erro ao carregar: ${snapshot.error ?? 'Pokémon não encontrado'}"),
            ),
          );
        }

        final pokemon = snapshot.data!;
        final capitalizedName = pokemon.name[0].toUpperCase() + pokemon.name.substring(1);
        final primaryType = pokemon.types.first;
        final typeColor = AppStyles.typeColors[primaryType] ?? AppStyles.typeColors['normal']!;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppStyles.primaryColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              '#${pokemon.id.toString().padLeft(3, '0')} $capitalizedName',
              style: GoogleFonts.inter(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              Consumer<FavoriteProvider>(
                builder: (context, favoriteProvider, child) {
                  final isFavorite = favoriteProvider.isFavorite(pokemon.name);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      final correctUrl = 'https://pokeapi.co/api/v2/pokemon/${pokemon.id}/';
                      final pokemonAsListItem = PokemonListItemModel(name: pokemon.name, url: correctUrl);
                      context.read<FavoriteProvider>().toggleFavorite(pokemonAsListItem);
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Container da Imagem com a cor do tipo
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  color: AppStyles.primaryColor, // A barra vermelha da AppBar continua
                  child: Container(
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Hero(
                      tag: pokemon.name, // Garante a animação da lista para os detalhes
                      child: Image.network(
                        pokemon.imageUrl,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                
                // Painel de Informações
                Transform.translate(
                  offset: const Offset(0, -20), // Puxa o painel branco para cima
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Type",
                          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children: pokemon.types.map((type) {
                            final typeChipColor = AppStyles.typeColors[type] ?? Colors.grey;
                            return Chip(
                              label: Text(
                                type[0].toUpperCase() + type.substring(1),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: typeChipColor,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          "Abilities",
                          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ...pokemon.abilities.map((ability) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              ability[0].toUpperCase() + ability.substring(1),
                              style: GoogleFonts.inter(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

