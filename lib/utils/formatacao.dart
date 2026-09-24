String normalizarPalavra(String palavra) {
  return palavra.toUpperCase().replaceAll('-', '').replaceAll(' ', '');
}
