import 'package:procura_palavras/services/gerador_tabuleiro.dart';
import 'package:procura_palavras/services/api_service.dart';
import 'package:procura_palavras/widgets/app_bar_jogo.dart';
import 'package:procura_palavras/widgets/tabuleiro.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> palavras = [];
  List<List<String>> matriz = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarJogo();
  }

  Future<void> carregarJogo() async {
    try {
      final palavrasApi = await ApiService.carregarPalavras(
        'portugues',
        'frutas',
      );

      final gerador = GeradorTabuleiro(tamanho: 10);

      final resultado = gerador.gerar(palavrasApi);

      setState(() {
        palavras = resultado.palavras;
        matriz = resultado.matriz;
        carregando = false;
      });
      print(resultado.palavras);
    } catch (e) {
      print('ERRO AO CARREGAR JOGO: $e');

      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarJogo(titulo: "Categoria"),
      body: Center(
        child: carregando
            ? const CircularProgressIndicator()
            : Tabuleiro(matriz: matriz, palavras: palavras),
      ),
    );
  }
}
