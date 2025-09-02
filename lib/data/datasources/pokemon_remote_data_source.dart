
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_list_item_model.dart';
import '../models/pokemon_detail_model.dart';

class PokemonRemoteDataSource {
  final String _baseUrl = "https://pokeapi.co/api/v2/";

  Future<List<PokemonListItemModel>> fetchPokemonList({int limit = 20, int offset = 0}) async {
    // buscar os Pokémon com base no limit e offset
    final response = await http.get(Uri.parse('${_baseUrl}pokemon?limit=$limit&offset=$offset'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((e) => PokemonListItemModel.fromJson(e)).toList();
    } else {
      throw Exception('Falha ao carregar a lista de Pokémon.');
    }
  }
  Future<PokemonDetailModel> fetchPokemonDetails(String pokemonUrl) async {
  final response = await http.get(Uri.parse(pokemonUrl));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return PokemonDetailModel.fromJson(data);
  } else {
    throw Exception('Falha ao carregar os detalhes do Pokémon.');
  }
}
}