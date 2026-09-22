class Categoria {
  final String key;
  final String name;

  Categoria({required this.key, required this.name});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(key: json['key'], name: json['name']);
  }
}
