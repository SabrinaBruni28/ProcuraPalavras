import 'package:procura_palavras/widgets/botao_jogo.dart';
import 'package:procura_palavras/models/categoria.dart';
import 'package:flutter/material.dart';

Widget listaCategorias({required List<Categoria> categorias}) {
  return ListView.builder(
    itemCount: categorias.length,
    itemBuilder: (context, index) {
      final categoria = categorias[index];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: botaoJogo(
          texto: categoria.name,
          onPressed: () {
            Navigator.of(context).pushNamed("/game", arguments: categoria.key);
          },
        ),
      );
    },
  );
}
