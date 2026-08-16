// Seed reference data for EU cosmetic ingredient classification.
//
// This is a small, hand-picked starting list — NOT the full EU COSING
// database (14,000+ substances). Anything not listed here is classified
// as "unknown" rather than assumed safe, see docs/data-sources.md.
// All names are lowercase INCI names for matching.

const Set<String> annexIiBanned = {
  'hydroquinone',
  'butylphenyl methylpropional',
  'lilial',
  'isobutylparaben',
  'isopropylparaben',
  'atranol',
  'chloroatranol',
  'musk ambrette',
};

const Set<String> annexIiiRestricted = {
  'triclosan',
  'salicylic acid',
  'retinol',
  'zinc pyrithione',
};

const Set<String> euFragranceAllergens = {
  'amyl cinnamal',
  'amylcinnamyl alcohol',
  'anisyl alcohol',
  'benzyl alcohol',
  'benzyl benzoate',
  'benzyl cinnamate',
  'benzyl salicylate',
  'cinnamal',
  'cinnamyl alcohol',
  'citral',
  'citronellol',
  'coumarin',
  'eugenol',
  'farnesol',
  'geraniol',
  'hexyl cinnamal',
  'hydroxycitronellal',
  'hydroxyisohexyl 3-cyclohexene carboxaldehyde',
  'isoeugenol',
  'limonene',
  'linalool',
  'methyl 2-octynoate',
  'alpha-isomethyl ionone',
  'evernia prunastri extract',
  'evernia furfuracea extract',
};
