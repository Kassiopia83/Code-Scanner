import '../data/ingredient_reference.dart';
import '../models/ingredient_rating.dart';

class IngredientClassifier {
  const IngredientClassifier();

  IngredientRating classify(String ingredientName) {
    final normalized = ingredientName.trim().toLowerCase();

    if (IngredientReferenceData.banned.contains(normalized)) {
      return IngredientRating.banned;
    }
    if (euFragranceAllergens.contains(normalized)) {
      return IngredientRating.allergen;
    }
    if (IngredientReferenceData.restricted.contains(normalized)) {
      return IngredientRating.restricted;
    }
    if (IngredientReferenceData.permitted.contains(normalized)) {
      return IngredientRating.permitted;
    }
    return IngredientRating.unknown;
  }
}
