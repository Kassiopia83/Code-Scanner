import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/open_beauty_facts_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.barcode});

  final String barcode;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _service = OpenBeautyFactsService();
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
              const SizedBox(height: 8),
              if (product.ingredients.isEmpty)
                const Text('Keine Inhaltsstoffliste hinterlegt.')
              else
                Text(product.ingredients.join(', ')),
            ],
          );
        },
      ),
    );
  }
}
