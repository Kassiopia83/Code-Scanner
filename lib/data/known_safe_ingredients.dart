// Hand-curated, deliberately small list of very common cosmetic
// ingredients with no EU restriction of any kind (not in any COSING
// annex, not a fragrance allergen, not on the microplastics list) — the
// ordinary, uncontroversial building blocks of most products (Aqua,
// Glycerin, Niacinamide, ...).
//
// This exists because otherwise ~everything not explicitly
// banned/restricted shows as gray "unknown", which is honest but
// unhelpful for the extremely common stuff that genuinely is just fine.
// It is NOT derived from a full COSING positive-listing import (that
// would need an authenticated API — see project notes) — it's a small,
// manually verified seed, the same way euFragranceAllergens is. Keep it
// that way: only add a name here after checking it doesn't already sit in
// banned/restricted/permitted/microplastics (would be a contradiction)
// and isn't controversial (no known emerging concern).
const Set<String> knownSafeIngredients = {
  'aqua',
  'water',
  'glycerin',
  'niacinamide',
  'panthenol',
  'sodium hyaluronate',
  'hyaluronic acid',
  'tocopherol',
  'tocopheryl acetate',
  'allantoin',
  'xanthan gum',
  'cetyl alcohol',
  'stearyl alcohol',
  'stearic acid',
  'glyceryl stearate',
  'cetearyl alcohol',
  'squalane',
  'caprylic/capric triglyceride',
  'sodium chloride',
  'citric acid',
  'sodium citrate',
  'butylene glycol',
  'propylene glycol',
  'pentylene glycol',
  'sorbitol',
  'urea',
  'lactic acid',
  'glycolic acid',
  'ascorbic acid',
  'bisabolol',
  'centella asiatica extract',
  'aloe barbadensis leaf juice',
  'caffeine',
  'betaine',
  'beta-glucan',
};
