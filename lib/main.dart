import 'package:procura_palavras/pages/categoria_page.dart';
import 'package:procura_palavras/pages/home_page.dart';
import 'package:procura_palavras/pages/game_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Procura Palavras",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.purple)),
      home: HomePage(),
      routes: {
        "/game": (context) => GamePage(),
        "/categoria": (context) => CategoriaPage(),
      },
    ),
  );
}
