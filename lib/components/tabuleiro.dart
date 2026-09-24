import 'package:procura_palavras/components/palavras_painter.dart';
import 'package:procura_palavras/components/selecao_painter.dart';
import 'package:procura_palavras/services/controlador_audio.dart';
import 'package:procura_palavras/components/lista_palavras.dart';
import 'package:procura_palavras/utils/tabuleiro_utils.dart';
import 'package:procura_palavras/services/jogo_service.dart';
import 'package:procura_palavras/utils/formatacao.dart';
import 'package:procura_palavras/utils/cores.dart';
import 'package:flutter/material.dart';

class Tabuleiro extends StatefulWidget {
  final List<List<String>> matriz;
  final List<String> palavras;
  final double tamanho;

  const Tabuleiro({
    super.key,
    required this.matriz,
    required this.palavras,
    required this.tamanho,
  });

  @override
  State<Tabuleiro> createState() => _TabuleiroState();
}

class _TabuleiroState extends State<Tabuleiro> {
  // Guarda as posições de cada palavra encontrada.
  final Map<String, List<Offset>> palavrasEncontradas = {};

  // Letras selecionadas durante o arrasto atual.
  final List<Offset> selecionadas = [];

  // Key para a lista de palavras
  final listaPalavrasKey = GlobalKey<ListaPalavrasState>();

  // Variáveis de funcionamento do jogo
  Offset? direcao;
  Offset? inicioToque;
  bool selecionando = false;

  // Variáveis para layout do jogo
  int get quantidade => widget.matriz.length;
  double get tamanhoCelula => widget.tamanho / quantidade;
  double get tamanhoFonte => (tamanhoCelula * 0.55).clamp(10.0, 25.0);

  void iniciarSelecao(Offset posicao) {
    final celula = obterCelula(posicao, widget.tamanho, tamanhoCelula);

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
    if (!selecionando || inicioToque == null) {
      return;
    }

    // Descobre a célula que está sendo tocada.
    final celulaAtual = obterCelula(posicao, widget.tamanho, tamanhoCelula);

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

    final palavra = obterPalavraSelecionada(selecionadas, widget.matriz);

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
    listaPalavrasKey.currentState?.rolarAtePalavra(palavraEncontrada);
    setState(() {
      palavrasEncontradas[palavraEncontrada!] = List.from(selecionadas);
    });
    ControladorAudio.tocarEfeito('acerto.mp3');

    print('Encontrou: $palavraEncontrada');

    // Encontrou todas as palavras
    if (palavrasEncontradas.length == widget.palavras.length) {
      finalizarJogo(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 500,
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListaPalavras(
            key: listaPalavrasKey,
            tamanhoFonte: tamanhoFonte,
            palavras: widget.palavras,
            palavrasEncontradas: palavrasEncontradas,
          ),
        ),

        SizedBox(height: 30),

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
            width: widget.tamanho,
            height: widget.tamanho,
            child: Stack(
              children: [
                // Palavras encontradas
                CustomPaint(
                  size: Size(widget.tamanho, widget.tamanho),
                  painter: PalavrasPainter(
                    palavrasEncontradas: palavrasEncontradas,
                    tamanhoCelula: tamanhoCelula,
                    cores: cores,
                  ),
                ),

                // Seleção atual
                CustomPaint(
                  size: Size(widget.tamanho, widget.tamanho),
                  painter: SelecaoPainter(
                    selecionadas: selecionadas,
                    tamanhoCelula: tamanhoCelula,
                  ),
                ),

                // Letras
                Column(
                  children: List.generate(quantidade, (linha) {
                    return Row(
                      children: List.generate(quantidade, (coluna) {
                        return SizedBox(
                          width: tamanhoCelula,
                          height: tamanhoCelula,
                          child: Center(
                            child: Text(
                              widget.matriz[linha][coluna],
                              style: TextStyle(
                                fontSize: tamanhoFonte,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
