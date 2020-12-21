import 'package:sql/model/pokemon.dart';
import 'package:sql/repository/pokemon_repository.dart';
import 'dart:async';

//The BLOC class communicates with the database through the DAO class
class PokemonBloc {
  final _pokemonRepository = PokemonRepository();
  final _pokemonController = StreamController<List<Pokemon>>.broadcast();
  get pokemons => _pokemonController.stream;

  PokemonBloc() {
    getPokemons();
  }

  //Adds a pokemon and registers a new event
  getPokemons({String query}) async {
    _pokemonController.sink.add(await _pokemonRepository.getAllPokemons(query: query));
  }

  addPokemon(Pokemon pokemon) async {
    await _pokemonRepository.insertPokemon(pokemon);
    getPokemons();
  }

  updatePokemon(Pokemon pokemon) async {
    await _pokemonRepository.updatePokemon(pokemon);
    getPokemons();
  }

  deletePokemonById(int id) async {
    _pokemonRepository.deletePokemonById(id);
    getPokemons();
  }

  dispose() {
    _pokemonController.close();
  }
}
