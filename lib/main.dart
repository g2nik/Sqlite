import 'package:flutter/material.dart';
import 'package:sql/ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fav pokemons',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        canvasColor: Colors.transparent
      ),
      home: HomePage(title: 'Fav pokemons'),
    );
  }
}
