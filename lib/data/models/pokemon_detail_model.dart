// lib/data/models/pokemon_detail_model.dart

class PokemonDetailModel {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final List<String> abilities;

  PokemonDetailModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.abilities,
  });

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    // Extrai a lista de tipos do JSON.
    // O JSON é uma lista de 'slots', e dentro de cada um tem um 'type' com um 'name'.
    final typesList = (json['types'] as List)
        .map((typeInfo) => typeInfo['type']['name'] as String)
        .toList();

    // Extrai a lista de habilidades de forma similar.
    final abilitiesList = (json['abilities'] as List)
        .map((abilityInfo) => abilityInfo['ability']['name'] as String)
        .toList();

    return PokemonDetailModel(
      id: json['id'],
      name: json['name'],
      // A URL da imagem fica dentro de sprites -> other -> official-artwork -> front_default
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      types: typesList,
      abilities: abilitiesList,
    );
  }
}