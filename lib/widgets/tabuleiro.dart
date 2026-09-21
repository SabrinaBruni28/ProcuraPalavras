import 'package:procura_palavras/widgets/palavras_painter.dart';
import 'package:procura_palavras/widgets/selecao_painter.dart';
import 'package:flutter/material.dart';

class Tabuleiro extends StatefulWidget {
  const Tabuleiro({super.key});

  @override
  State<Tabuleiro> createState() => _TabuleiroState();
}

class _TabuleiroState extends State<Tabuleiro> {
  final matriz = [
    ['C', 'A', 'S', 'A', 'R'],
    ['T', 'B', 'O', 'L', 'A'],
    ['P', 'A', 'T', 'O', 'S'],
    ['M', 'E', 'S', 'A', 'D'],
    ['R', 'I', 'O', 'F', 'L'],
  ];

  final palavras = ['CASAR', 'BOLA', 'PATO', 'MESA', 'RIO', 'LOAF'];

  // Guarda as posições de cada palavra encontrada.
  final Map<String, List<Offset>> palavrasEncontradas = {};

  // Letras selecionadas durante o arrasto atual.
  final List<Offset> selecionadas = [];

  bool selecionando = false;
  bool jogoFinalizado = false;

  Offset? inicioToque;
  Offset? direcao;

  static const double tamanho = 400;

  // Cores usadas para as palavras encontradas.
  final List<Color> cores = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
  ];

  int get quantidade => matriz.length;

  double get tamanhoCelula => tamanho / quantidade;

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
    if (!selecionando || inicioToque == null || jogoFinalizado) return;

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
          linha < matriz.length &&
          coluna >= 0 &&
          coluna < matriz[0].length) {
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
        .map((posicao) => matriz[posicao.dx.toInt()][posicao.dy.toInt()])
        .join();
  }

  void conferePalavra(String palavra) {
    String? palavraEncontrada;

    if (palavras.contains(palavra)) {
      palavraEncontrada = palavra;
    } else {
      final invertida = palavra.split('').reversed.join();

      if (palavras.contains(invertida)) {
        palavraEncontrada = invertida;
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

    // Verifica se todas as palavras foram encontradas.
    if (palavrasEncontradas.length == palavras.length) {
      finalizarJogo();
    }
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
              },
              child: const Text('Continuar'),
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

  // Retorna a cor da palavra encontrada.
  Color corDaPalavra(int indice) {
    return cores[indice % cores.length];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            // Palavras que já foram encontradas
            CustomPaint(
              size: const Size(tamanho, tamanho),
              painter: PalavrasPainter(
                palavrasEncontradas: palavrasEncontradas,
                tamanhoCelula: tamanhoCelula,
                cores: cores,
              ),
            ),

            // Seleção que está sendo feita neste momento
            CustomPaint(
              size: const Size(tamanho, tamanho),
              painter: SelecaoPainter(
                selecionadas: selecionadas,
                tamanhoCelula: tamanhoCelula,
              ),
            ),

            // Letras
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: 25,
              itemBuilder: (context, index) {
                final linha = index ~/ 5;
                final coluna = index % 5;

                return Center(
                  child: Text(
                    matriz[linha][coluna],
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
    );
  }
}
