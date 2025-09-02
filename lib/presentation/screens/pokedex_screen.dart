// lib/presentation/screens/pokedex_screen.dart

import 'package:flutter/material.dart';
import '../../data/datasources/pokemon_remote_data_source.dart';
import '../../data/models/pokemon_list_item_model.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';
import 'favorites_screen.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final PokemonRemoteDataSource _dataSource = PokemonRemoteDataSource();
  final TextEditingController _searchController = TextEditingController();

  List<PokemonListItemModel> _pokemonList = [];
  int _offset = 0;
  final int _limit = 20;
  bool _isLoading = false;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _loadMorePokemons();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMorePokemons() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newPokemons = await _dataSource.fetchPokemonList(
        limit: _limit,
        offset: _offset,
      );
      setState(() {
        _pokemonList.addAll(newPokemons);
        _offset += _limit;
        _isFirstLoad = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao carregar mais Pokémon: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          const SnackBar(content: Text('Pokémon não encontrado!')),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Meus Favoritos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
        ],
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
            child: _isFirstLoad
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(12.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _pokemonList.isEmpty ? 0 : _pokemonList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < _pokemonList.length) {
                        final pokemon = _pokemonList[index];
                        return PokemonCard(pokemon: pokemon);
                      } else {
                        return Center(
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _loadMorePokemons,
                                  child: const Text('Carregar Mais'),
                                ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}