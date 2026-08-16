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
          final healthFlags = classifications
              .where((e) => e.classification.isHealthFlag)
              .toList();
          final palmOil = classifications
              .where((e) => e.classification.isPalmOilDerived)
              .toList();
          final mineralOil = classifications
              .where((e) => e.classification.isMineralOilDerived)
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
                _HealthSummaryCard(
                  healthFlags: healthFlags,
                  palmOil: palmOil,
                  mineralOil: mineralOil,
                ),
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
                'Rot = verboten, Gelb = eingeschränkt/Duftstoff-Allergen, '
                'Orange = zugelassen mit Auflagen, Blau = häufig als '
                'Mikroplastik eingesetzt (NGO-Liste, keine offizielle '
                'EU-Stoffliste). Details zu jedem Stoff per Fingerdruck '
                'auf den Chip. "Nicht erfasst" heißt nicht "unbedenklich".',
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

typedef _ClassifiedIngredient =
    ({String name, IngredientClassification classification});

class _HealthSummaryCard extends StatelessWidget {
  const _HealthSummaryCard({
    required this.healthFlags,
    required this.palmOil,
    required this.mineralOil,
  });

  final List<_ClassifiedIngredient> healthFlags;
  final List<_ClassifiedIngredient> palmOil;
  final List<_ClassifiedIngredient> mineralOil;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAnything =
        healthFlags.isNotEmpty || palmOil.isNotEmpty || mineralOil.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (hasAnything ? Colors.red : Colors.green).withValues(
          alpha: 0.08,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (hasAnything ? Colors.red : Colors.green).withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gesundheitsrelevante Hinweise',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (!hasAnything)
            const Text(
              'Keine krebserregenden/potenziell krebserregenden oder '
              'sonst krankmachenden Stoffe, kein Palmöl, kein Mineralöl '
              'anhand der Zutatenliste erkannt.',
            ),
          if (healthFlags.isNotEmpty)
            _SummarySection(
              title: 'Krebserregend / potenziell krankmachend',
              entries: healthFlags,
            ),
          if (palmOil.isNotEmpty) ...[
            if (healthFlags.isNotEmpty) const SizedBox(height: 12),
            _SummarySection(title: 'Palmöl enthalten', entries: palmOil),
          ],
          if (mineralOil.isNotEmpty) ...[
            if (healthFlags.isNotEmpty || palmOil.isNotEmpty)
              const SizedBox(height: 12),
            _SummarySection(title: 'Mineralöl enthalten', entries: mineralOil),
          ],
        ],
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.title, required this.entries});

  final String title;
  final List<_ClassifiedIngredient> entries;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
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
