// One-off parser for the Beat the Microbead "Red List" of microplastic
// ingredients (Plastic Soup Foundation), as extracted to plain text via
// `pdftotext -layout` from:
// https://www.beatthemicrobead.org/wp-content/uploads/2022/01/RED-LIST-05.01.2022.pdf
//
// Run with: dart run tool/parse_microplastics_list.dart <path-to-txt>
// Prints a sorted, deduplicated JSON array of lowercase ingredient names.
//
// This is NOT re-run automatically like update_ingredient_data.dart: the
// source is a static, infrequently-updated PDF (not an API), so this
// script is kept for documentation/reproducibility rather than as a
// scheduled job.

import 'dart:convert';
import 'dart:io';

final _numberedLine = RegExp(r'^\s*(\d+)\s+(.*)$');
final _sourceOnlyLine = RegExp(
  r'^\s*(ECHA|UNEP|Synonym with|Polyvinylpyrrolidone)\s*;?\s*$',
);
final _footerLine = RegExp(r'^Updated \d');
final _headerLine = RegExp(r'^NO\.\s+RED POLYMER');

void main(List<String> args) {
  final path = args.isEmpty ? '/tmp/redlist.txt' : args[0];
  final lines = File(path).readAsLinesSync();

  final names = <String>{};
  String? currentName;

  void flush() {
    if (currentName == null) return;
    final cleaned = _cleanName(currentName!);
    if (_looksValid(cleaned)) {
      names.add(cleaned);
      // Real ingredient lists almost always use the plain name, not the
      // parenthetical abbreviation ("Polyethylene", not "Polyethylene
      // (PE)") — add the stripped variant too so both can match.
      final withoutParens = cleaned
          .replaceAll(RegExp(r'\s*\([^)]*\)\s*$'), '')
          .trim();
      if (withoutParens != cleaned && _looksValid(withoutParens)) {
        names.add(withoutParens);
      }
    }
    currentName = null;
  }

  for (final rawLine in lines) {
    final line = rawLine.trimRight();
    if (line.trim().isEmpty ||
        _footerLine.hasMatch(line) ||
        _headerLine.hasMatch(line) ||
        _sourceOnlyLine.hasMatch(line.trim())) {
      continue;
    }

    final match = _numberedLine.firstMatch(line);
    if (match != null) {
      flush();
      currentName = match.group(2)!;
    } else if (currentName != null) {
      // Continuation of a wrapped name from the previous numbered line.
      currentName = '${currentName!} ${line.trim()}';
    }
  }
  flush();

  final sorted = names.toList()..sort();
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(sorted));
  stderr.writeln('Parsed ${sorted.length} unique names.');
}

/// Strips the trailing CAS-number/source columns (e.g. "... Copolymer
/// 176429-87-1 ECHA") off a raw name line, and lowercases it.
String _cleanName(String raw) {
  final firstColumn = raw.split(RegExp(r'\s{2,}')).first;
  return firstColumn.trim().toLowerCase();
}

final _casPattern = RegExp(r'\d{2,7}-\d{2}-\d');

/// Rejects PDF-extraction artifacts: lines that are implausibly long, or
/// that embed multiple CAS numbers (a sign several table rows got merged
/// into one name by mistake).
bool _looksValid(String name) {
  if (name.length < 3 || name.length > 80) return false;
  if (_casPattern.allMatches(name).length > 1) return false;
  return true;
}
