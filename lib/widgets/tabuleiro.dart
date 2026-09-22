import 'package:procura_palavras/widgets/palavras_painter.dart';
import 'package:procura_palavras/widgets/selecao_painter.dart';
import 'package:flutter/material.dart';

class Tabuleiro extends StatefulWidget {
  final List<List<String>> matriz;
  final List<String> palavras;

  const Tabuleiro({super.key, required this.matriz, required this.palavras});

  @override
  State<Tabuleiro> createState() => _TabuleiroState();
}

class _TabuleiroState extends State<Tabuleiro> {
  // Guarda as posições de cada palavra encontrada.
  final Map<String, List<Offset>> palavrasEncontradas = {};

  // Letras selecionadas durante o arrasto atual.
  final List<Offset> selecionadas = [];

  // Controla a rolagem horizontal da lista de palavras.
  final ScrollController palavrasScrollController = ScrollController();

  // Permite localizar cada palavra dentro da lista.
  late final List<GlobalKey> palavrasKeys;

  bool selecionando = false;
  bool jogoFinalizado = false;

  Offset? inicioToque;
  Offset? direcao;

  static const double tamanho = 450;

  // Cores usadas para as palavras encontradas.
  final List<Color> cores = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.brown,
    Colors.yellowAccent,
    Colors.cyan,
  ];

  int get quantidade => widget.matriz.length;

  double get tamanhoCelula => tamanho / quantidade;

  @override
  void initState() {
    super.initState();

    // Cria uma chave para cada palavra.
    palavrasKeys = List.generate(widget.palavras.length, (_) => GlobalKey());
  }

  @override
  void dispose() {
    palavrasScrollController.dispose();
    super.dispose();
  }

  void iniciarSelecao(Offset posicao) {
    if (jogoFinalizado) return;

    final celula = obterCelula(posicao);

    if (celula == null) return;

    setState(() {
      selecionando = true;
      selecionadas.clear();

      inicioToque = posicao;
      direcao = null;

      selecionadas.add(celula);
    });
  }

  void atualizarSelecao(Offset posicao) {
    if (!selecionando || inicioToque == null || jogoFinalizado) {
      return;
    }

    final movimento = posicao - inicioToque!;

    if (movimento.distance < tamanhoCelula * 0.25) {
      return;
    }

    final dx = movimento.dx;
    final dy = movimento.dy;

    Offset novaDirecao;

    if (dx.abs() > dy.abs() * 1.5) {
      // Horizontal
      novaDirecao = Offset(0, dx.sign);
    } else if (dy.abs() > dx.abs() * 1.5) {
      // Vertical
      novaDirecao = Offset(dy.sign, 0);
    } else {
      // Diagonal
      novaDirecao = Offset(dy.sign, dx.sign);
    }

    direcao = novaDirecao;

    final distancia = movimento.distance;
    final quantidade = (distancia / tamanhoCelula).round();

    final inicio = selecionadas.first;

    final novasSelecionadas = <Offset>[];

    for (int i = 0; i <= quantidade; i++) {
      final linha = inicio.dx + direcao!.dx * i;
      final coluna = inicio.dy + direcao!.dy * i;

      if (linha >= 0 &&
          linha < widget.matriz.length &&
          coluna >= 0 &&
          coluna < widget.matriz[0].length) {
        novasSelecionadas.add(Offset(linha, coluna));
      }
    }

    setState(() {
      selecionadas
        ..clear()
        ..addAll(novasSelecionadas);
    });
  }

  void finalizarSelecao() {
    if (!selecionando) return;

    final palavra = obterPalavraSelecionada();

    if (palavra != null) {
      conferePalavra(palavra);
    }

    setState(() {
      selecionando = false;
      selecionadas.clear();
      inicioToque = null;
      direcao = null;
    });
  }

  String? obterPalavraSelecionada() {
    if (selecionadas.isEmpty) {
      return null;
    }

    return selecionadas
        .map((posicao) => widget.matriz[posicao.dx.toInt()][posicao.dy.toInt()])
        .join();
  }

  String normalizarPalavra(String palavra) {
    return palavra.toUpperCase().replaceAll('-', '').replaceAll(' ', '');
  }

  void conferePalavra(String palavra) {
    String? palavraEncontrada;

    final palavraNormalizada = normalizarPalavra(palavra);

    for (final palavraLista in widget.palavras) {
      final palavraListaNormalizada = normalizarPalavra(palavraLista);

      // Verifica na direção normal.
      if (palavraListaNormalizada == palavraNormalizada) {
        palavraEncontrada = palavraLista;
        break;
      }
    }

    if (palavraEncontrada == null) {
      return;
    }

    // Impede encontrar a mesma palavra novamente.
    if (palavrasEncontradas.containsKey(palavraEncontrada)) {
      return;
    }

    setState(() {
      palavrasEncontradas[palavraEncontrada!] = List.from(selecionadas);
    });

    print('Encontrou: $palavraEncontrada');

    rolarAtePalavra(palavraEncontrada);

    if (palavrasEncontradas.length == widget.palavras.length) {
      finalizarJogo();
    }
  }

  void rolarAtePalavra(String palavra) {
    final indice = widget.palavras.indexOf(palavra);

    if (indice == -1) return;

    final context = palavrasKeys[indice].currentContext;

    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.5,
    );
  }

  void finalizarJogo() {
    if (jogoFinalizado) return;

    setState(() {
      jogoFinalizado = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Parabéns! 🎉'),
          content: const Text('Você encontrou todas as palavras!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Menu'),
            ),
          ],
        );
      },
    );
  }

  Offset? obterCelula(Offset posicao) {
    if (posicao.dx < 0 ||
        posicao.dy < 0 ||
        posicao.dx >= tamanho ||
        posicao.dy >= tamanho) {
      return null;
    }

    final coluna = (posicao.dx / tamanhoCelula).floor();
    final linha = (posicao.dy / tamanhoCelula).floor();

    return Offset(linha.toDouble(), coluna.toDouble());
  }

  Widget listaPalavras() {
    return Scrollbar(
      controller: palavrasScrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: palavrasScrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(widget.palavras.length, (index) {
            final palavra = widget.palavras[index];
            final encontrada = palavrasEncontradas.containsKey(palavra);

            return Padding(
              key: palavrasKeys[index],
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  palavra,
                  style: TextStyle(
                    fontSize: 18,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 30,
      children: [
        Container(
          width: 500,
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: listaPalavras(),
        ),

        GestureDetector(
          onPanStart: (details) {
            iniciarSelecao(details.localPosition);
          },
          onPanUpdate: (details) {
            atualizarSelecao(details.localPosition);
          },
          onPanEnd: (_) {
            finalizarSelecao();
          },
          child: SizedBox(
            width: tamanho,
            height: tamanho,
            child: Stack(
              children: [
                // Palavras que já foram encontradas.
                CustomPaint(
                  size: const Size(tamanho, tamanho),
                  painter: PalavrasPainter(
                    palavrasEncontradas: palavrasEncontradas,
                    tamanhoCelula: tamanhoCelula,
                    cores: cores,
                  ),
                ),

                // Seleção que está sendo feita neste momento.
                CustomPaint(
                  size: const Size(tamanho, tamanho),
                  painter: SelecaoPainter(
                    selecionadas: selecionadas,
                    tamanhoCelula: tamanhoCelula,
                  ),
                ),

                // Letras.
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: quantidade,
                  ),
                  itemCount: quantidade * quantidade,
                  itemBuilder: (context, index) {
                    final linha = index ~/ quantidade;
                    final coluna = index % quantidade;

                    return Center(
                      child: Text(
                        widget.matriz[linha][coluna],
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
