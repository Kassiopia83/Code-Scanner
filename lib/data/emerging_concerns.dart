// Hand-curated, deliberately small list of ingredients with a documented
// scientific/media concern that is NOT (yet) reflected in EU cosmetics law
// — unlike everything else in this app, these are not COSING-derived and
// carry no regulatory weight. Every entry needs an actually-checked source
// before being added; this is not a place to guess from memory. Extend
// this list only when a specific substance has been researched, the way
// Octocrylene was (see product-status notes for 2026-08-16).

class EmergingConcern {
  const EmergingConcern({required this.description, required this.source});

  /// Plain-language explanation of the concern, in German.
  final String description;

  /// Short citation of where this claim comes from.
  final String source;
}

const Map<String, EmergingConcern> emergingConcerns = {
  'octocrylene': EmergingConcern(
    description:
        'Kann sich mit der Zeit — vor allem in älteren oder falsch '
        'gelagerten Produkten — zu Benzophenon zersetzen. Benzophenon '
        'wird von der IARC als "möglicherweise krebserregend beim '
        'Menschen" (Gruppe 2B) eingestuft und ist seit Dezember 2023 in '
        'der EU als Kosmetik-Inhaltsstoff verboten. Octocrylene selbst '
        'ist weiterhin ein regulär zugelassener EU-UV-Filter — es gibt '
        'aktuell keine EU-Beschränkung für Octocrylene selbst.',
    source:
        'IARC-Einstufung von Benzophenon; Studien zur Octocrylene-'
        'Zersetzung (Stand 2026) — keine EU-Rechtsgrundlage für '
        'Octocrylene selbst',
  ),
};
