
import 'package:flutter/material.dart';
import '../../data/datasources/pokemon_remote_data_source.dart';
import '../../data/models/pokemon_list_item_model.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  late Future<List<PokemonListItemModel>> _pokemonListFuture;
  final PokemonRemoteDataSource _dataSource = PokemonRemoteDataSource();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pokemonListFuture = _dataSource.fetchPokemonList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchPokemon() async {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    final String url = 'https://pokeapi.co/api/v2/pokemon/$query';
    try {
      await _dataSource.fetchPokemonDetails(url);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailScreen(pokemonUrl: url),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pokémon não encontrado!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex Explorer'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por nome ou número',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchPokemon,
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PokemonListItemModel>>(
              future: _pokemonListFuture, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Ocorreu um erro: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum Pokémon encontrado.'));
                }
                final pokemons = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,      // 2 colunas
                    crossAxisSpacing: 12.0, // Espaçamento horizontal
                    mainAxisSpacing: 12.0,  // Espaçamento vertical 
                    childAspectRatio: 1.0,  // Proporção (largura/altura) 
                  ),
                  itemCount: pokemons.length,
                  itemBuilder: (context, index) {
                    final pokemon = pokemons[index];
                    return PokemonCard(pokemon: pokemon);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}