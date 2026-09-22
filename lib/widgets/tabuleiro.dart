import 'package:procura_palavras/services/controlador_audio.dart';
import 'package:procura_palavras/widgets/palavras_painter.dart';
import 'package:procura_palavras/widgets/selecao_painter.dart';
import 'package:procura_palavras/widgets/caixa_dialogo.dart';
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
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
    Colors.lime,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.blueGrey,
    Colors.amber,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.cyanAccent,
    Colors.orangeAccent,
    Colors.tealAccent,
    Colors.indigoAccent,
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

    // Descobre a célula que está sendo tocada.
    final celulaAtual = obterCelula(posicao);

    if (celulaAtual == null) {
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

    final inicio = selecionadas.first;

    final linhaInicial = inicio.dx.toInt();
    final colunaInicial = inicio.dy.toInt();

    final linhaAtual = celulaAtual.dx.toInt();
    final colunaAtual = celulaAtual.dy.toInt();

    // Verifica quantas células existem entre o início
    // e a célula atualmente tocada.
    final diferencaLinha = linhaAtual - linhaInicial;
    final diferencaColuna = colunaAtual - colunaInicial;

    int quantidade;

    if (novaDirecao.dx != 0) {
      quantidade = diferencaLinha.abs();
    } else {
      quantidade = diferencaColuna.abs();
    }

    final novasSelecionadas = <Offset>[];

    for (int i = 0; i <= quantidade; i++) {
      final linha = linhaInicial + novaDirecao.dx.toInt() * i;
      final coluna = colunaInicial + novaDirecao.dy.toInt() * i;

      if (linha >= 0 &&
          linha < widget.matriz.length &&
          coluna >= 0 &&
          coluna < widget.matriz[0].length) {
        novasSelecionadas.add(Offset(linha.toDouble(), coluna.toDouble()));
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

    // Não encontrou
    if (palavraEncontrada == null) {
      ControladorAudio.tocarEfeito('erro.mp3');
      return;
    }

    // Impede encontrar a mesma palavra novamente.
    if (palavrasEncontradas.containsKey(palavraEncontrada)) {
      return;
    }

    // Encontrou palavra
    setState(() {
      palavrasEncontradas[palavraEncontrada!] = List.from(selecionadas);
    });
    ControladorAudio.tocarEfeito('acerto.mp3');

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
    CaixaDialogo.mostrar(context);
    ControladorAudio.tocarMusica('venceu.mp3');
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
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 500,
          height: 90,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.matriz[linha][coluna],
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
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
