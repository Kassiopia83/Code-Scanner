class Product {
  const Product({required this.barcode, this.name, this.brand, this.ingredientsText});

  final String barcode;
  final String? name;
  final String? brand;
  final String? ingredientsText;

  List<String> get ingredients {
    final text = ingredientsText;
    if (text == null || text.isEmpty) return [];
    return text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
