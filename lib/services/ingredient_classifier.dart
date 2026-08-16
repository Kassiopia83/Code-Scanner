import '../data/ingredient_reference.dart';
import '../models/ingredient_rating.dart';

class IngredientClassification {
  const IngredientClassification({required this.rating, this.cmr});

  final IngredientRating rating;

  /// Readable CMR classification (e.g. "krebserregend Kat. 1B"), if COSING
  /// lists one for this ingredient.
  final String? cmr;

  String get tooltip => cmr == null ? rating.label : '${rating.label} ($cmr)';
}

class IngredientClassifier {
  const IngredientClassifier();

  IngredientClassification classify(String ingredientName) {
    final normalized = ingredientName.trim().toLowerCase();

    if (IngredientReferenceData.banned.contains(normalized)) {
      return IngredientClassification(
        rating: IngredientRating.banned,
        cmr: IngredientReferenceData.bannedCmr[normalized],
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
    return const IngredientClassification(rating: IngredientRating.unknown);
  }
}
