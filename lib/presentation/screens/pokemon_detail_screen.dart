import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // NOVO: Importa o pacote provider
import '../../data/datasources/pokemon_remote_data_source.dart';
import '../../data/models/pokemon_detail_model.dart';
import '../providers/favorite_provider.dart';

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
            appBar: AppBar(backgroundColor: Colors.red),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Erro"), backgroundColor: Colors.red),
            body: Center(child: Text("Erro ao carregar: ${snapshot.error}")),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text("Não encontrado"), backgroundColor: Colors.red),
            body: const Center(child: Text("Pokémon não encontrado.")),
          );
        }

        final pokemon = snapshot.data!;
        final capitalizedName = pokemon.name[0].toUpperCase() + pokemon.name.substring(1);

        final favoriteProvider = context.watch<FavoriteProvider>();
        final isFavorite = favoriteProvider.isFavorite(pokemon.id);

        return Scaffold(
          appBar: AppBar(
            title: Text(capitalizedName),
            backgroundColor: Colors.red,
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.yellow : Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  context.read<FavoriteProvider>().toggleFavorite(pokemon.id);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(pokemon.imageUrl, height: 250, fit: BoxFit.contain),
                  const SizedBox(height: 16),
                  Text(
                    capitalizedName,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '#${pokemon.id.toString().padLeft(3, '0')}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Text('Tipos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pokemon.types.map((type) => Chip(label: Text(type))).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text('Habilidades', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Column(
                    children: pokemon.abilities.map((ability) => Text(ability)).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}