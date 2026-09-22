import 'package:procura_palavras/widgets/app_bar_jogo.dart';
import 'package:procura_palavras/widgets/texto_jogo.dart';
import 'package:procura_palavras/widgets/botao_jogo.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarJogo(titulo: "Procura Palavras"),

      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
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
                  TextoJogo(texto: "PROCURA PALAVRAS"),
                ],
              ),

              SizedBox(
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: [
                    BotaoJogo(
                      texto: "Jogar",
                      onPressed: () =>
                          Navigator.of(context).pushNamed("/categoria"),
                    ),
                    BotaoJogo(
                      texto: "Configurações",
                      onPressed: () =>
                          Navigator.of(context).pushNamed("/configuracao"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
