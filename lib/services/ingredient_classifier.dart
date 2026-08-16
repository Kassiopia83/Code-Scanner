import '../data/ingredient_reference.dart';
import '../models/ingredient_rating.dart';

class IngredientClassification {
  const IngredientClassification({
    required this.rating,
    this.cmr,
    this.isConditional = false,
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
    return buffer.toString();
  }
}

class IngredientClassifier {
  const IngredientClassifier();

  IngredientClassification classify(String ingredientName) {
    final normalized = ingredientName.trim().toLowerCase();

    if (IngredientReferenceData.banned.contains(normalized)) {
      return IngredientClassification(
        rating: IngredientRating.banned,
        cmr: IngredientReferenceData.bannedCmr[normalized],
        isConditional: IngredientReferenceData.bannedConditional.contains(
          normalized,
        ),
      );
    }
    if (euFragranceAllergens.contains(normalized)) {
      return const IngredientClassification(rating: IngredientRating.allergen);
    }
    if (IngredientReferenceData.restricted.contains(normalized)) {
      return IngredientClassification(
        rating: IngredientRating.restricted,
        cmr: IngredientReferenceData.restrictedCmr[normalized],
      );
    }
    if (IngredientReferenceData.permitted.contains(normalized)) {
      return const IngredientClassification(
        rating: IngredientRating.permitted,
      );
    }
    if (IngredientReferenceData.microplastics.contains(normalized)) {
      return const IngredientClassification(
        rating: IngredientRating.microplastic,
      );
    }
    return const IngredientClassification(rating: IngredientRating.unknown);
  }
}
