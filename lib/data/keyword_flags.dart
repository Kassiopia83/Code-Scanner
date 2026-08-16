// Substring-based (not exact-match) ingredient flags — used for questions
// that can't be answered with an exact-name lookup because the substance
// appears under many different INCI names.
//
// Palm oil: INCI naming doesn't reliably indicate the vegetable source of
// many derivatives (e.g. Sodium Lauryl Sulfate or Glycerin could be palm-,
// coconut- or other plant-derived — the label alone can't tell you which).
// This can only catch names that explicitly say "Palm" or "Elaeis
// Guineensis" (the palm tree's botanical name) — a real, known limitation
// of INCI labeling, not a gap in this matching logic.
const List<String> palmOilKeywords = ['palm', 'elaeis guineensis'];

// Mineral oil / petroleum derivatives commonly used as emollients,
// waxes, or texturizers.
const List<String> mineralOilKeywords = [
  'paraffin',
  'petrolatum',
  'mineral oil',
  'microcristallina',
  'ozokerite',
  'ceresin',
];
