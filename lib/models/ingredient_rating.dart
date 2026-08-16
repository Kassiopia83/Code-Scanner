import 'package:flutter/material.dart';

enum IngredientRating {
  banned,
  restricted,
  allergen,
  permitted,
  unknown;

  Color get color {
    switch (this) {
      case IngredientRating.banned:
        return Colors.red;
      case IngredientRating.restricted:
      case IngredientRating.allergen:
        return Colors.amber;
      case IngredientRating.permitted:
        return Colors.orange.shade800;
      case IngredientRating.unknown:
        return Colors.grey;
    }
  }

  String get label {
    switch (this) {
      case IngredientRating.banned:
        return 'In der EU verboten';
      case IngredientRating.restricted:
        return 'Nur eingeschränkt zulässig (EU)';
      case IngredientRating.allergen:
        return 'Deklarationspflichtiges Duftstoff-Allergen';
      case IngredientRating.permitted:
        return 'Zugelassener Farbstoff/Konservierungsstoff/UV-Filter mit Auflagen (EU)';
      case IngredientRating.unknown:
        return 'Nicht in der Referenzliste erfasst';
    }
  }
}
