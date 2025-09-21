import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/datasources/pokemon_remote_data_source.dart';
import '../../data/models/pokemon_list_item_model.dart';
import '../styles/app_styles.dart';
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
  final ScrollController _scrollController = ScrollController();

  List<PokemonListItemModel> _pokemonList = [];
  int _offset = 0;
  final int _limit = 20;
  bool _isLoading = false;
  bool _isFirstLoad = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadMorePokemons();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.9 &&
          !_isLoadingMore) {
        _loadMorePokemons();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMorePokemons() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (_offset > 0) {
        _isLoadingMore = true;
      }
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
          SnackBar(content: Text('Falha ao carregar Pokémon: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _searchPokemon() async {
    final rawQuery = _searchController.text.trim().toLowerCase();
    if (rawQuery.isEmpty) return;

    final String url = 'https://pokeapi.co/api/v2/pokemon/$rawQuery';
    try {
      // Valida se o pokemon existe antes de navegar
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppStyles.primaryColor,
        elevation: 4.0,
        centerTitle: true,
        title: Text(
          'Pokédex',
          style: GoogleFonts.pressStart2p(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Colors.white, size: 28),
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
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _searchPokemon(),
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou número',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12.0),
                   borderSide: const BorderSide(color: AppStyles.secondaryColor, width: 2),
                )
              ),
            ),
          ),
          Expanded(
            child: _isFirstLoad
                ? const Center(child: CircularProgressIndicator(color: AppStyles.secondaryColor))
                : GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _pokemonList.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                       if (index == _pokemonList.length) {
                        return const Center(child: CircularProgressIndicator(color: AppStyles.secondaryColor));
                      }
                      final pokemon = _pokemonList[index];
                      return PokemonCard(
                        pokemon: pokemon,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PokemonDetailScreen(pokemonUrl: pokemon.url),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
