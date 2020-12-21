import 'dart:async';
import 'package:sql/database/database.dart';
import 'package:sql/model/pokemon.dart';

//This class acts as an intermediary between the BLOC and the database
class PokemonDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createPokemon(Pokemon pokemon) async {
    final db = await dbProvider.database;
    var result = db.insert(pokemonTABLE, pokemon.toDatabaseJson());
    return result;
  }
  //If the query passed is not null not empty it searches data within the database
  //that coincides with the pattern (query)
  Future<List<Pokemon>> getPokemons({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(pokemonTABLE,
          columns: columns,
          where: 'name LIKE ?',
          whereArgs: ["%$query%"]);
    } else {
      result = await db.query(pokemonTABLE, columns: columns);
    }

    List<Pokemon> pokemons = result.isNotEmpty
    ? result.map((item) => Pokemon.fromDatabaseJson(item)).toList()
    : [];
    return pokemons;
  }

  Future<int> updatePokemon(Pokemon pokemon) async {
    final db = await dbProvider.database;

    var result = await db.update(pokemonTABLE, pokemon.toDatabaseJson(),
        where: "id = ?", whereArgs: [pokemon.id]);

    return result;
  }

  Future<int> deletePokemon(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(pokemonTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }
}
