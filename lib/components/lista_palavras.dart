import 'package:flutter/material.dart';

class ListaPalavras extends StatefulWidget {
  final double tamanhoFonte;
  final List<String> palavras;
  final Map<String, List<Offset>> palavrasEncontradas;

  const ListaPalavras({
    super.key,
    required this.tamanhoFonte,
    required this.palavras,
    required this.palavrasEncontradas,
  });

  @override
  State<ListaPalavras> createState() => ListaPalavrasState();
}

class ListaPalavrasState extends State<ListaPalavras> {
  final ScrollController palavrasScrollController = ScrollController();
  late List<GlobalKey> palavrasKeys;

  @override
  void initState() {
    super.initState();

    // Cria uma chave para cada palavra.
    palavrasKeys = List.generate(widget.palavras.length, (_) => GlobalKey());
  }

  @override
  void didUpdateWidget(covariant ListaPalavras oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.palavras != widget.palavras) {
      palavrasKeys = List.generate(widget.palavras.length, (_) => GlobalKey());
    }
  }

  @override
  void dispose() {
    palavrasScrollController.dispose();
    super.dispose();
  }

  void rolarAtePalavra(String palavra) {
    final indice = widget.palavras.indexOf(palavra);

    if (indice == -1) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final context = palavrasKeys[indice].currentContext;

      if (context == null) return;

      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      controller: palavrasScrollController,
      child: SingleChildScrollView(
        controller: palavrasScrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 15,
          children: List.generate(widget.palavras.length, (index) {
            final palavra = widget.palavras[index];
            final encontrada = widget.palavrasEncontradas.containsKey(palavra);

            return Padding(
              key: palavrasKeys[index],
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  palavra,
                  style: TextStyle(
                    fontSize: widget.tamanhoFonte - 5,
                    fontWeight: FontWeight.bold,
                    decoration: encontrada
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: encontrada ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
