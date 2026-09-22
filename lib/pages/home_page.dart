import 'package:procura_palavras/widgets/app_bar_jogo.dart';
import 'package:procura_palavras/widgets/botao_jogo.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarJogo(titulo: "Procura Palavras"),
      body: Container(
        width: double.infinity,
        height: 800,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 80,
          children: [
            Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icone.png", width: 150),
                Text(
                  "PROCURA PALAVRAS",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            BotaoJogo(
              texto: "Jogar",
              onPressed: () => Navigator.of(context).pushNamed("/game"),
            ),
          ],
        ),
      ),
    );
  }
}
