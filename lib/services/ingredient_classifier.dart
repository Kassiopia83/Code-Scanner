import '../data/emerging_concerns.dart';
import '../data/ingredient_reference.dart';
import '../data/keyword_flags.dart';
import '../models/ingredient_rating.dart';

class IngredientClassification {
  const IngredientClassification({
    required this.rating,
    this.cmr,
    this.isConditional = false,
    this.emergingConcern,
    this.isPalmOilDerived = false,
    this.isMineralOilDerived = false,
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

  final bool isPalmOilDerived;
  final bool isMineralOilDerived;

  /// Worth surfacing in the health-focused summary at the top of the
  /// product screen: banned substances, restricted/microplastic entries
  /// with a documented CMR reason, or anything with a researched emerging
  /// concern — even if the concern is a processing/degradation byproduct
  /// rather than the listed substance itself (e.g. Octocrylene). Pure
  /// fragrance allergens are deliberately excluded: that's a declaration
  /// requirement for people with contact allergies, not a "makes you
  /// sick" signal, so it doesn't belong in a health-risk summary.
  bool get isHealthFlag =>
      rating == IngredientRating.banned ||
      rating == IngredientRating.microplastic ||
      (rating == IngredientRating.restricted && cmr != null) ||
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
    if (isPalmOilDerived) {
      buffer.write(
        ' — Name enthält "Palm": möglicherweise palmölbasiert (aus der '
        'INCI-Bezeichnung allein nicht sicher bestimmbar)',
      );
    }
    if (isMineralOilDerived) {
      buffer.write(' — mineralölbasierter Inhaltsstoff (Erdöl-Derivat)');
    }
    return buffer.toString();
  }
}

class IngredientClassifier {
  const IngredientClassifier();

  IngredientClassification classify(String ingredientName) {
    final normalized = ingredientName.trim().toLowerCase();

    IngredientRating rating;
    String? cmr;
    var isConditional = false;

    if (IngredientReferenceData.banned.contains(normalized)) {
      rating = IngredientRating.banned;
      cmr = IngredientReferenceData.bannedCmr[normalized];
      isConditional = IngredientReferenceData.bannedConditional.contains(
        normalized,
      );
    } else if (euFragranceAllergens.contains(normalized)) {
      rating = IngredientRating.allergen;
    } else if (IngredientReferenceData.restricted.contains(normalized)) {
      rating = IngredientRating.restricted;
      cmr = IngredientReferenceData.restrictedCmr[normalized];
    } else if (IngredientReferenceData.permitted.contains(normalized)) {
      rating = IngredientRating.permitted;
    } else if (IngredientReferenceData.microplastics.contains(normalized)) {
      rating = IngredientRating.microplastic;
    } else {
      rating = IngredientRating.unknown;
    }

    return IngredientClassification(
      rating: rating,
      cmr: cmr,
      isConditional: isConditional,
      emergingConcern: emergingConcerns[normalized],
      isPalmOilDerived: palmOilKeywords.any(normalized.contains),
      isMineralOilDerived: mineralOilKeywords.any(normalized.contains),
    );
  }
}
