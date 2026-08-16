import '../data/emerging_concerns.dart';
import '../data/ingredient_reference.dart';
import '../models/ingredient_rating.dart';

class IngredientClassification {
  const IngredientClassification({
    required this.rating,
    this.cmr,
    this.isConditional = false,
    this.emergingConcern,
  });

  final IngredientRating rating;

  /// Readable CMR classification (e.g. "krebserregend Kat. 1B"), if COSING
  /// lists one for this ingredient.
  final String? cmr;

  /// True if the EU ban has a documented exception (e.g. Petrolatum is
  /// banned "except if the full refining history is known and it can be
  /// shown that the substance ... is not a carcinogen") — a flat "verboten"
  /// would overstate this.
  final bool isConditional;

  /// A documented scientific/media concern that isn't (yet) EU-regulated
  /// (e.g. Octocrylene). Independent of [rating] — a permitted ingredient
  /// can still have one.
  final EmergingConcern? emergingConcern;

  /// Worth surfacing in a product-level summary: anything EU-flagged
  /// (banned/restricted/allergen/microplastic) or with a documented
  /// emerging concern. Plain "permitted, nothing notable" ingredients are
  /// excluded so the summary doesn't drown in routine UV filters etc.
  bool get isNotable =>
      (rating != IngredientRating.unknown &&
          rating != IngredientRating.permitted) ||
      emergingConcern != null;

  String get tooltip {
    final buffer = StringBuffer(rating.label);
    if (cmr != null) buffer.write(' ($cmr)');
    if (isConditional) {
      buffer.write(' — mit Ausnahmeregelung, siehe COSING-Originaltext');
    }
    if (rating == IngredientRating.microplastic) {
      buffer.write(
        ' — Quelle: Beat the Microbead "Red List" (Stand 01/2022), keine '
        'offizielle EU-Stoffliste und breiter gefasst als die rechtliche '
        'REACH-Definition',
      );
    }
    if (emergingConcern != null) {
      buffer.write(' — ${emergingConcern!.description}');
    }
    return buffer.toString();
  }
}

class IngredientClassifier {
  const IngredientClassifier();

  IngredientClassification classify(String ingredientName) {
    final normalized = ingredientName.trim().toLowerCase();
    final concern = emergingConcerns[normalized];

    if (IngredientReferenceData.banned.contains(normalized)) {
      return IngredientClassification(
        rating: IngredientRating.banned,
        cmr: IngredientReferenceData.bannedCmr[normalized],
        isConditional: IngredientReferenceData.bannedConditional.contains(
          normalized,
        ),
        emergingConcern: concern,
      );
    }
    if (euFragranceAllergens.contains(normalized)) {
      return IngredientClassification(
        rating: IngredientRating.allergen,
        emergingConcern: concern,
      );
    }
    if (IngredientReferenceData.restricted.contains(normalized)) {
      return IngredientClassification(
        rating: IngredientRating.restricted,
        cmr: IngredientReferenceData.restrictedCmr[normalized],
        emergingConcern: concern,
      );
    }
    if (IngredientReferenceData.permitted.contains(normalized)) {
      return IngredientClassification(
        rating: IngredientRating.permitted,
        emergingConcern: concern,
      );
    }
    if (IngredientReferenceData.microplastics.contains(normalized)) {
      return IngredientClassification(
        rating: IngredientRating.microplastic,
        emergingConcern: concern,
      );
    }
    return IngredientClassification(
      rating: IngredientRating.unknown,
      emergingConcern: concern,
    );
  }
}
