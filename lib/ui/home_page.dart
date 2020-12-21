import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sql/bloc/pokemon_bloc.dart';
import 'package:sql/model/pokemon.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  //We load our Pokemon BLoC that is used to get
  //the stream of Pokemon for StreamBuilder
  final PokemonBloc pokemonBloc = PokemonBloc();
  final String title;

  //Allows Pokemon card to register horizontal swipes
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.amber,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));
    return Scaffold(
      backgroundColor: Colors.grey[700],
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child: Container(
                color: Colors.grey[700],
                padding:
                    const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0, top: 24),
                child: Container(
                    //This is where the magic starts
                    child: getPokemonsWidget()))),
        bottomNavigationBar: BottomAppBar(
          color: Colors.grey[900],
          child: Container(
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(color: Colors.grey, width: 0.3),
            )),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.amber,
                      size: 28,
                    ),
                    onPressed: () {
                      //just re-pull UI for testing purposes
                      pokemonBloc.getPokemons();
                    }),
                Expanded(
                  child: Text(
                    "Pokemon",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'RobotoMono',
                        fontStyle: FontStyle.normal,
                        fontSize: 19),
                  ),
                ),
                Wrap(children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      _showPokemonSearchSheet(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                  )
                ])
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 25),
          child: FloatingActionButton(
            elevation: 5.0,
            onPressed: () {
              _showAddPokemonSheet(context);
            },
            backgroundColor: Colors.grey[800],
            child: Icon(
              Icons.add,
              size: 32,
              color: Colors.amber,
            ),
          ),
        ));
  }

  void _showAddPokemonSheet(BuildContext context) {
    final _pokemonDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: new BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _pokemonDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400, color: Colors.amber),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'Typhlosion, Arceus, Empoleon',
                                  hintStyle: TextStyle(color: Colors.amberAccent),
                                  labelText: 'New Pokemon',
                                  labelStyle: TextStyle( color: Colors.amber, fontWeight: FontWeight.w500, fontSize: 30)),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Empty description!';
                                }
                                return value.contains('')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.amber,
                              radius: 18,
                              child: IconButton(
                                icon: Icon( Icons.save, size: 22, color: Colors.black),
                                onPressed: () {
                                  final newPokemon = Pokemon(name: _pokemonDescriptionFormController.value.text);
                                  if (newPokemon.name.isNotEmpty) {
                                    /*Create new Pokemon object and make sure
                                    the Pokemon description is not empty,
                                    because what's the point of saving empty
                                    Pokemon
                                    */
                                    pokemonBloc.addPokemon(newPokemon);

                                    //dismisses the bottomsheet
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showPokemonSearchSheet(BuildContext context) {
    final _pokemonSearchDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: new BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _pokemonSearchDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400, color: Colors.amber),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search for pokemon...',
                                hintStyle: TextStyle(color: Colors.amber),
                                labelText: 'Search',
                                labelStyle: TextStyle(color: Colors.amberAccent, fontSize: 30, fontWeight: FontWeight.w500),
                              ),
                              validator: (String value) => value.contains('@') ? 'Do not use the @ char.' : null,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.amber,
                              radius: 18,
                              child: IconButton(
                                icon: Icon( Icons.search, size: 22, color: Colors.black),
                                onPressed: () {
                                  /*This will get all pokemons
                                  that contains similar string
                                  in the textform
                                  */
                                  pokemonBloc.getPokemons(query: _pokemonSearchDescriptionFormController.value.text);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getPokemonsWidget() {
    /*The StreamBuilder widget,
    basically this widget will take stream of data (pokemons)
    and construct the UI (with state) based on the stream
    */
    return StreamBuilder(
      stream: pokemonBloc.pokemons,
      builder: (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
        return getPokemonCardWidget(snapshot);
      },
    );
  }

  Widget getPokemonCardWidget(AsyncSnapshot<List<Pokemon>> snapshot) {
    /*Since most of our operations are asynchronous
    at initial state of the operation there will be no stream
    so we need to handle it if this was the case
    by showing users a processing/loading indicator*/
    if (snapshot.hasData) {
      /*Also handles whenever there's stream
      but returned returned 0 records of Pokemon from DB.
      If that the case show user that you have empty Pokemons
      */
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Pokemon pokemon = snapshot.data[itemPosition];
                final Widget dismissibleCard = new Dismissible(
                  background: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Deleting",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    color: Colors.redAccent,
                  ),
                  onDismissed: (direction) {
                    /*The magic
                    delete Pokemon item by ID whenever
                    the card is dismissed
                    */
                    pokemonBloc.deletePokemonById(pokemon.id);
                  },
                  direction: _dismissDirection,
                  key: new ObjectKey(pokemon),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text(
                          pokemon.name,
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 16.5,
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.w500,),
                        ),
                      )),
                );
                return dismissibleCard;
              },
            )
          : Container(
              child: Center(
              //this is used whenever there 0 Pokemon
              //in the data base
              child: noPokemonMessageWidget(),
            ));
    } else {
      return Center(
        /*since most of our I/O operations are done
        outside the main thread asynchronously
        we may want to display a loading indicator
        to let the use know the app is currently
        processing*/
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    //pull pokemons again
    pokemonBloc.getPokemons();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget noPokemonMessageWidget() {
    return Container(
      child: Text(
        "Start adding Pokemon...",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Colors.amberAccent),
      ),
    );
  }

  dispose() {
    /*close the stream in order
    to avoid memory leaks
    */
    pokemonBloc.dispose();
  }
}
