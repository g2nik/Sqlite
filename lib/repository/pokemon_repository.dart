import 'package:sql/dao/pokemon_dao.dart';
import 'package:sql/model/pokemon.dart';

class PokemonRepository {
  final pokemonDao = PokemonDao();

  Future getAllPokemons({String query}) => pokemonDao.getPokemons(query: query);

  Future insertPokemon(Pokemon pokemon) => pokemonDao.createPokemon(pokemon);

  Future updatePokemon(Pokemon pokemon) => pokemonDao.updatePokemon(pokemon);

  Future deletePokemonById(int id) => pokemonDao.deletePokemon(id);
}
