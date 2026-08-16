// Downloads the EU CosIng cosmetic regulation annexes (II-VI) and
// regenerates assets/data/ingredient_reference.json from them.
//
// Run with: dart run tool/update_ingredient_data.dart
//
// Source: the official EU Commission CosIng export API, as used by
// https://github.com/biobricks-ai/cosing (no public docs page links this
// endpoint directly, but it is the Commission's own CosIng tool backend).
// COSING annexes change several times a year (SCCS opinions, CLP-driven
// bans), so this script should be re-run occasionally rather than treated
// as a one-off.

import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

const _annexes = ['II', 'III', 'IV', 'V', 'VI'];

Uri _csvUrl(String annex) => Uri.parse(
  'https://api.tech.ec.europa.eu/cosing20/1.0/api/annexes/$annex/export-csv',
);

Future<void> main() async {
  final banned = <String>{};
  final restricted = <String>{};
  final permitted = <String>{};
  String? sourceLastUpdate;

  for (final annex in _annexes) {
    stdout.writeln('Downloading Annex $annex...');
    final response = await http.get(_csvUrl(annex));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch Annex $annex: ${response.statusCode}');
    }
    final body = response.body;
    sourceLastUpdate ??= _extractLastUpdate(body);

    // The export has 4 metadata lines (creation date, annex title, list
    // title, section header) before the real column header row.
    final rows = csv.decode(body).skip(4).toList();
    if (rows.isEmpty) continue;

    final header = rows.first.map((e) => e.toString().trim()).toList();
    final dataRows = rows.skip(1);

    int? indexOf(String columnName) {
      final idx = header.indexOf(columnName);
      return idx == -1 ? null : idx;
    }

    switch (annex) {
      case 'II':
        final col = indexOf('Identified INGREDIENTS or substances e.g.');
        if (col == null) break;
        for (final row in dataRows) {
          banned.addAll(_splitNames(row[col].toString(), ','));
        }
      case 'III':
        final col = indexOf('Name of Common Ingredients Glossary');
        if (col == null) break;
        for (final row in dataRows) {
          restricted.addAll(_splitNames(row[col].toString(), '/'));
        }
      case 'IV':
        final col = indexOf(
          'Colour index Number / Name of Common Ingredients Glossary',
        );
        if (col == null) break;
        for (final row in dataRows) {
          permitted.addAll(
            _splitNames(
              row[col].toString(),
              '/',
            ).where((name) => !RegExp(r'^ci\s*\d+$').hasMatch(name)),
          );
        }
      case 'V':
      case 'VI':
        final col = indexOf('Name of Common Ingredients Glossary');
        if (col == null) break;
        for (final row in dataRows) {
          permitted.addAll(_splitNames(row[col].toString(), '/'));
        }
      default:
        break;
    }
  }

  final output = {
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'sourceLastUpdate': sourceLastUpdate,
    'banned': banned.toList()..sort(),
    'restricted': restricted.toList()..sort(),
    'permitted': permitted.toList()..sort(),
  };

  final outFile = File('assets/data/ingredient_reference.json');
  await outFile.create(recursive: true);
  await outFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(output),
  );

  stdout.writeln(
    'Wrote ${banned.length} banned, ${restricted.length} restricted, '
    '${permitted.length} permitted ingredient names to ${outFile.path}',
  );
}

final _footnoteMarker = RegExp(r'^\(\d+\)\s*');

Iterable<String> _splitNames(String raw, String separator) sync* {
  for (final part in raw.split(separator)) {
    final name = part
        .trim()
        .toLowerCase()
        .replaceFirst(_footnoteMarker, '')
        .trim();
    if (name.length < 3 || name == '-') continue;
    yield name;
  }
}

String? _extractLastUpdate(String csvBody) {
  final match = RegExp(r'Last update:\s*([\d/]+)').firstMatch(csvBody);
  return match?.group(1);
}
