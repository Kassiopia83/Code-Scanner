import '../data/ingredient_reference.dart';
import '../models/ingredient_rating.dart';

class IngredientClassifier {
  const IngredientClassifier();

  IngredientRating classify(String ingredientName) {
    final normalized = ingredientName.trim().toLowerCase();

    if (annexIiBanned.contains(normalized)) return IngredientRating.banned;
    if (annexIiiRestricted.contains(normalized)) {
      return IngredientRating.restricted;
    }
    if (euFragranceAllergens.contains(normalized)) {
      return IngredientRating.allergen;
    }
    return IngredientRating.unknown;
  }
}
