import 'dart:math';

class ResultadoTabuleiro {
  final List<List<String>> matriz;
  final List<String> palavras;

  ResultadoTabuleiro({required this.matriz, required this.palavras});
}

class GeradorTabuleiro {
  final int tamanho;
  final Random random;

  GeradorTabuleiro({required this.tamanho, Random? random})
    : random = random ?? Random();

  ResultadoTabuleiro gerar(List<String> palavras) {
    final matriz = List.generate(tamanho, (_) => List.filled(tamanho, ''));

    final palavrasValidas = palavras
        .map(
          (palavra) =>
              palavra.toUpperCase().replaceAll('-', '').replaceAll(' ', ''),
        )
        .where((palavra) => palavra.length <= tamanho)
        .where((palavra) => palavra.isNotEmpty)
        .toList();

    palavrasValidas.shuffle(random);

    final palavrasSelecionadas = <String>[];

    for (final palavra in palavrasValidas) {
      try {
        colocarPalavra(matriz, palavra);
        palavrasSelecionadas.add(palavra);
      } catch (_) {
        // Se não couber, simplesmente tenta a próxima.
      }
    }

    preencherVazios(matriz);

    return ResultadoTabuleiro(matriz: matriz, palavras: palavrasSelecionadas);
  }

  void colocarPalavra(List<List<String>> matriz, String palavra) {
    final direcoes = [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1],
    ];

    direcoes.shuffle(random);

    for (int tentativa = 0; tentativa < 1000; tentativa++) {
      final direcao = direcoes[random.nextInt(direcoes.length)];

      final linha = random.nextInt(tamanho);
      final coluna = random.nextInt(tamanho);

      final direcaoLinha = direcao[0];
      final direcaoColuna = direcao[1];

      if (!podeColocar(
        matriz,
        palavra,
        linha,
        coluna,
        direcaoLinha,
        direcaoColuna,
      )) {
        continue;
      }

      for (int i = 0; i < palavra.length; i++) {
        final novaLinha = linha + direcaoLinha * i;

        final novaColuna = coluna + direcaoColuna * i;

        matriz[novaLinha][novaColuna] = palavra[i];
      }

      return;
    }

    throw Exception('Não foi possível colocar a palavra "$palavra".');
  }

  bool podeColocar(
    List<List<String>> matriz,
    String palavra,
    int linha,
    int coluna,
    int direcaoLinha,
    int direcaoColuna,
  ) {
    for (int i = 0; i < palavra.length; i++) {
      final novaLinha = linha + direcaoLinha * i;

      final novaColuna = coluna + direcaoColuna * i;

      if (novaLinha < 0 ||
          novaLinha >= tamanho ||
          novaColuna < 0 ||
          novaColuna >= tamanho) {
        return false;
      }

      final letraAtual = matriz[novaLinha][novaColuna];

      if (letraAtual.isNotEmpty && letraAtual != palavra[i]) {
        return false;
      }
    }

    return true;
  }

  void preencherVazios(List<List<String>> matriz) {
    const letras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    for (int linha = 0; linha < tamanho; linha++) {
      for (int coluna = 0; coluna < tamanho; coluna++) {
        if (matriz[linha][coluna].isEmpty) {
          matriz[linha][coluna] = letras[random.nextInt(letras.length)];
        }
      }
    }
  }
}
