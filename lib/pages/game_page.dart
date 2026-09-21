import 'package:flutter/material.dart';
import 'package:procura_palavras/widgets/tabuleiro.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> palavras = ["sabrina", "luiz", "baby", "selmira", "eugenio"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Center(child: Tabuleiro()),
    );
  }
}
