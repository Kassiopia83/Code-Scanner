import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductNotFoundException implements Exception {}

class ProductFetchTimeoutException implements Exception {}

class OpenBeautyFactsService {
  Future<Product> fetchProduct(String barcode) async {
    final uri = Uri.https(
      'world.openbeautyfacts.org',
      '/api/v2/product/$barcode.json',
    );
    final response = await http
        .get(uri)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw ProductFetchTimeoutException(),
        );

    // Open Beauty Facts answers "not found" with HTTP 404 and a
    // {"status":0} body, not with HTTP 200 — so 404 is a valid response to
    // parse, not necessarily an error.
    if (response.statusCode != 200 && response.statusCode != 404) {
      throw Exception(
        'Fehler beim Abrufen der Produktdaten (${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['status'] != 1) {
      throw ProductNotFoundException();
    }

    final product = data['product'] as Map<String, dynamic>;
    final ingredientsDe = product['ingredients_text_de'] as String?;
    final ingredients =
        (ingredientsDe != null && ingredientsDe.trim().isNotEmpty)
        ? ingredientsDe
        : product['ingredients_text'] as String?;

    return Product(
      barcode: barcode,
      name: product['product_name'] as String?,
      brand: product['brands'] as String?,
      ingredientsText: ingredients,
    );
  }
}
