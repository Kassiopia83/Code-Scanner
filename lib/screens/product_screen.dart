import 'package:flutter/material.dart';

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
          final classifications = [
            for (final ingredient in product.ingredients)
              (name: ingredient, classification: _classifier.classify(ingredient)),
          ];
          final notable = classifications
              .where((e) => e.classification.isNotable)
              .toList();

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
              if (product.ingredients.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Auffälligkeiten',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _SummaryText(entries: notable),
              ],
              const SizedBox(height: 16),
              Text(
                'Inhaltsstoffe',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Regulatorische Einstufung nach EU-Kosmetikverordnung '
                '(COSING, Anhänge II-VI), keine toxikologische Bewertung. '
                'Blau = häufig als Mikroplastik eingesetzt, nach einer '
                'NGO-Liste (Beat the Microbead), nicht nach einer '
                'offiziellen EU-Stoffliste. Einzelne Hinweise zu '
                'wissenschaftlich/medial diskutierten, aber (noch) nicht '
                'EU-regulierten Risiken sind separat gekennzeichnet. '
                '"Nicht erfasst" heißt nicht "unbedenklich".',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              if (product.ingredients.isEmpty)
                const Text('Keine Inhaltsstoffliste hinterlegt.')
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: classifications
                      .map(
                        (e) => _IngredientChip(
                          name: e.name,
                          classification: e.classification,
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

class _SummaryText extends StatelessWidget {
  const _SummaryText({required this.entries});

  final List<({String name, IngredientClassification classification})>
  entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Text(
        'Keine auffälligen Inhaltsstoffe gefunden (kein Verbot, keine '
        'Einschränkung, kein Allergen, kein Mikroplastik, keine '
        'dokumentierten aufkommenden Risiken).',
      );
    }
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                style: bodyStyle,
                children: [
                  TextSpan(
                    text: '${entry.name}: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: entry.classification.tooltip),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({required this.name, required this.classification});

  final String name;
  final IngredientClassification classification;

  @override
  Widget build(BuildContext context) {
    final color = classification.rating.color;
    return Tooltip(
      message: classification.tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(name),
          ],
        ),
      ),
    );
  }
}
