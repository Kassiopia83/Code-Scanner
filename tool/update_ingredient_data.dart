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
  final bannedCmr = <String, String>{};
  final restrictedCmr = <String, String>{};
  final bannedConditional = <String>{};
  final permittedConditions = <String, String>{};
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

    final cmrCol = indexOf('CMR');
    final maxConcentrationCol = indexOf(
      'Maximum concentration in ready for use preparation',
    );
    final productTypeCol = indexOf('Product Type, body parts');

    void recordCondition(List<String> names, List<dynamic> row) {
      final condition = _cleanCondition(
        maxConcentrationCol == null ? '' : row[maxConcentrationCol].toString(),
        productTypeCol == null ? '' : row[productTypeCol].toString(),
      );
      if (condition == null) return;
      for (final name in names) {
        permittedConditions[name] = condition;
      }
    }

    switch (annex) {
      case 'II':
        final col = indexOf('Identified INGREDIENTS or substances e.g.');
        final chemicalNameCol = indexOf('Chemical name / INN');
        if (col == null) break;
        for (final row in dataRows) {
          final names = _splitNames(row[col].toString(), ',').toList();
          banned.addAll(names);
          final cmr = cmrCol == null
              ? null
              : _cleanCmr(row[cmrCol].toString());
          if (cmr != null) {
            for (final name in names) {
              bannedCmr[name] = cmr;
            }
          }
          // Some Annex II entries are conditional bans (e.g. "Petrolatum,
          // except if the full refining history is known and it can be
          // shown that the substance from which it is produced is not a
          // carcinogen") rather than unconditional ones — flag those so
          // the UI doesn't overstate a flat ban.
          final chemicalName = chemicalNameCol == null
              ? ''
              : row[chemicalNameCol].toString();
          if (_conditionalException.hasMatch(chemicalName)) {
            bannedConditional.addAll(names);
          }
        }
      case 'III':
        final col = indexOf('Name of Common Ingredients Glossary');
        if (col == null) break;
        for (final row in dataRows) {
          final names = _splitNames(row[col].toString(), '/').toList();
          restricted.addAll(names);
          final cmr = cmrCol == null
              ? null
              : _cleanCmr(row[cmrCol].toString());
          if (cmr != null) {
            for (final name in names) {
              restrictedCmr[name] = cmr;
            }
          }
        }
      case 'IV':
        final col = indexOf(
          'Colour index Number / Name of Common Ingredients Glossary',
        );
        if (col == null) break;
        for (final row in dataRows) {
          final names = _splitNames(row[col].toString(), '/')
              .where((name) => !RegExp(r'^ci\s*\d+$').hasMatch(name))
              .toList();
          permitted.addAll(names);
          recordCondition(names, row);
        }
      case 'V':
      case 'VI':
        final col = indexOf('Name of Common Ingredients Glossary');
        if (col == null) break;
        for (final row in dataRows) {
          final names = _splitNames(row[col].toString(), '/').toList();
          permitted.addAll(names);
          recordCondition(names, row);
        }
      default:
        break;
    }
  }

  final outFile = File('assets/data/ingredient_reference.json');

  // This tool only produces the COSING-derived keys. A few keys are merged
  // in separately from non-COSING sources with their own scripts
  // (microplastics: tool/parse_microplastics_list.dart; knownSafe: hand-
  // curated) — preserve whatever is already on disk for those instead of
  // wiping them on every re-run. This bit was missed once already (see
  // project memory) and silently broke the microplastics category for a
  // whole commit.
  const preservedKeys = ['microplastics', 'microplasticsSource', 'knownSafe', 'knownSafeSource'];
  final preserved = <String, dynamic>{};
  if (outFile.existsSync()) {
    final existing =
        jsonDecode(await outFile.readAsString()) as Map<String, dynamic>;
    for (final key in preservedKeys) {
      if (existing.containsKey(key)) preserved[key] = existing[key];
    }
  }

  final output = {
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'sourceLastUpdate': sourceLastUpdate,
    'banned': banned.toList()..sort(),
    'restricted': restricted.toList()..sort(),
    'permitted': permitted.toList()..sort(),
    'bannedCmr': bannedCmr,
    'restrictedCmr': restrictedCmr,
    'bannedConditional': bannedConditional.toList()..sort(),
    'permittedConditions': permittedConditions,
    ...preserved,
  };

  await outFile.create(recursive: true);
  await outFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(output),
  );

  if (preserved.containsKey('microplastics')) {
    stdout.writeln(
      'Preserved ${(preserved['microplastics'] as List).length} '
      'microplastics names from the existing file.',
    );
  } else {
    stdout.writeln(
      'WARNING: no existing "microplastics" key found to preserve — run '
      'tool/parse_microplastics_list.dart and merge it in if this is '
      'unexpected.',
    );
  }

  stdout.writeln(
    'Wrote ${banned.length} banned (${bannedCmr.length} with CMR info, '
    '${bannedConditional.length} conditional), ${restricted.length} '
    'restricted (${restrictedCmr.length} with CMR info), '
    '${permitted.length} permitted (${permittedConditions.length} with '
    'condition info) ingredient names to ${outFile.path}',
  );
}

final _conditionalException = RegExp(r'\b(except|unless)\b', caseSensitive: false);

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

final _startsNumeric = RegExp(r'^\d');

/// Combines the "Maximum concentration" and "Product Type, body parts"
/// columns into one readable condition string (e.g. "max. 7,34 % (Face
/// products with the exception of propellent spray products)"), or null
/// if both are empty. Some "concentration" cells are actually free-text
/// usage notes (e.g. "Not to be used in products applied on mucous
/// membranes") rather than a number — only prefix "max." when the value
/// actually starts with a digit. Cells can also contain embedded
/// newlines (multi-line footnotes within one CSV field), which are
/// collapsed to spaces.
String? _cleanCondition(String rawConcentration, String rawProductType) {
  final concentration = rawConcentration.trim().replaceAll('\n', ' ').trim();
  final productType = rawProductType.trim().replaceAll('\n', ' ').trim();
  final hasConcentration = concentration.isNotEmpty && concentration != '-';
  final hasProductType = productType.isNotEmpty && productType != '-';

  final concentrationText = hasConcentration
      ? (_startsNumeric.hasMatch(concentration)
            ? 'max. $concentration'
            : concentration)
      : null;

  if (concentrationText == null && !hasProductType) return null;
  if (concentrationText != null && hasProductType) {
    return '$concentrationText ($productType)';
  }
  return concentrationText ?? productType;
}

/// Turns the raw CMR column (e.g. "Carcinogenic Cat. 1B(),Mutagenic Cat.
/// 2()") into a readable German label, or null if the column was empty.
String? _cleanCmr(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty || trimmed == '-') return null;
  final cleaned = trimmed
      .replaceAll('()', '')
      .replaceAll('Carcinogenic', 'krebserregend')
      .replaceAll('Mutagenic', 'mutagen')
      .replaceAll('Reprotoxic', 'fortpflanzungsgefährdend')
      .replaceAll('Cat.', 'Kat.')
      .replaceAll(',', ', ')
      .trim();
  return cleaned.isEmpty ? null : cleaned;
}
