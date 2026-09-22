import 'package:procura_palavras/services/gerador_tabuleiro.dart';
import 'package:procura_palavras/widgets/app_bar_jogo.dart';
import 'package:procura_palavras/services/api_service.dart';
import 'package:procura_palavras/widgets/tabuleiro.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String categoria = "";
  List<String> palavras = [];
  List<List<String>> matriz = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      carregarJogo();
    });
  }

  Future<void> carregarJogo() async {
    try {
      setState(() {
        categoria = ModalRoute.of(context)!.settings.arguments as String;
      });

      print('Categoria recebida: $categoria');

      final palavrasApi = await ApiService.carregarPalavras(
        'portugues',
        categoria,
      );

      final gerador = GeradorTabuleiro(tamanho: 10);

      final resultado = gerador.gerar(palavrasApi);

      print('Palavras selecionadas: ${resultado.palavras}');

      setState(() {
        palavras = resultado.palavras;
        matriz = resultado.matriz;
        carregando = false;
      });
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
      appBar: AppBarJogo(titulo: categoria.toUpperCase()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final tamanho = constraints.maxWidth.clamp(300.0, 450.0);
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: carregando
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                      child: Center(
                        child: Tabuleiro(
                          matriz: matriz,
                          palavras: palavras,
                          tamanho: tamanho,
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
