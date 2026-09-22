import 'package:procura_palavras/services/api_service.dart';
import 'package:procura_palavras/widgets/app_bar_jogo.dart';
import 'package:procura_palavras/widgets/botao_jogo.dart';
import 'package:procura_palavras/widgets/texto_jogo.dart';
import 'package:procura_palavras/models/categoria.dart';
import 'package:flutter/material.dart';

class CategoriaPage extends StatefulWidget {
  const CategoriaPage({super.key});

  @override
  State<CategoriaPage> createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  List<Categoria> categorias = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarCategoria();
  }

  Future<void> carregarCategoria() async {
    try {
      final categoriasApi = await ApiService.carregarCategorias('portugues');

      setState(() {
        categorias = categoriasApi;
        carregando = false;
      });
    } catch (e) {
      print('ERRO AO CARREGAR CATEGORIAS: $e');

      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarJogo(titulo: 'Categoria'),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: 500,
                height:
                    MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,

                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 20,
                  children: [
                    const TextoJogo(texto: "Escolha uma categoria:"),
                    Expanded(child: listaCategorias()),
                  ],
                ),
              ),
            ),
    );
  }

  Widget listaCategorias() {
    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: BotaoJogo(
            texto: categoria.name,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed("/game", arguments: categoria.key);
            },
          ),
        );
      },
    );
  }
}
