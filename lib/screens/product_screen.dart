import 'package:flutter/material.dart';

import '../models/ingredient_rating.dart';
import '../models/product.dart';
import '../services/ingredient_classifier.dart';
import '../services/open_beauty_facts_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.barcode});

  final String barcode;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _service = OpenBeautyFactsService();
  final _classifier = const IngredientClassifier();
  late final Future<Product> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchProduct(widget.barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Barcode ${widget.barcode}')),
      body: FutureBuilder<Product>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final error = snapshot.error;
            final String message;
            if (error is ProductNotFoundException) {
              message =
                  'Produkt nicht in der Open-Beauty-Facts-Datenbank gefunden.';
            } else if (error is ProductFetchTimeoutException) {
              message =
                  'Zeitüberschreitung beim Laden. Prüfe deine Internetverbindung und versuche es erneut.';
            } else {
              message =
                  'Fehler beim Laden der Produktdaten. Prüfe deine Internetverbindung.';
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(message, textAlign: TextAlign.center),
              ),
            );
          }

          final product = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                product.name ?? 'Unbenanntes Produkt',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (product.brand != null && product.brand!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  product.brand!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Inhaltsstoffe',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Regulatorische Einstufung nach EU-Kosmetikverordnung, keine '
                'toxikologische Bewertung. Basiert auf einer kleinen, nicht '
                'vollständigen Startliste — "nicht erfasst" heißt nicht '
                '"unbedenklich".',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              if (product.ingredients.isEmpty)
                const Text('Keine Inhaltsstoffliste hinterlegt.')
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: product.ingredients
                      .map(
                        (ingredient) => _IngredientChip(
                          name: ingredient,
                          rating: _classifier.classify(ingredient),
                        ),
                      )
                      .toList(),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({required this.name, required this.rating});

  final String name;
  final IngredientRating rating;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: rating.label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: rating.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: rating.color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: rating.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(name),
          ],
        ),
      ),
    );
  }
}
