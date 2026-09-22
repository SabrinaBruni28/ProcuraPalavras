import 'package:procura_palavras/models/categoria.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class ApiService {
  static const String baseApi = 'https://sabrinabruni28.github.io/forca-api/';

  static Future<List<Categoria>> carregarCategorias(String idioma) async {
    final url = Uri.parse('$baseApi$idioma/index.json');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar categorias');
    }

    final data = jsonDecode(response.body);

    return (data['categorias'] as List)
        .map((categoria) => Categoria.fromJson(categoria))
        .toList();
  }

  static Future<List<String>> carregarPalavras(
    String idioma,
    String categoria,
  ) async {
    final url = Uri.parse('$baseApi$idioma/$categoria.json');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar palavras');
    }

    final data = jsonDecode(response.body);

    return List<String>.from(data['palavras']);
  }
}
