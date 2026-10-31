---
typ: statisch
bereich: produkt
produkt: Code-Scanner
quelle: Material
aktualisiert: 2026-10-31
---

# Tech-Stack und Architektur

## Übersicht
Technischer Aufbau des Code-Scanners. Claude Code nutzt das Dokument, damit Vorschläge zum vorhandenen Stack und zur Ordnerstruktur passen. Fachliche Datenquellen im Detail stehen in [data-sources.md](data-sources.md), das Setup in [setup-installation.md](setup-installation.md).

## Stack
- Flutter (Dart, SDK ^3.13), Zielplattform Android; zusätzlich Web-Build für den klickbaren Portfolio-Prototyp.
- Pakete: `mobile_scanner` (Barcode-Scan über ML Kit), `http` (API-Abfrage), `csv` (nur Dev, Import der COSING-Daten).
- Lints: `flutter_lints`.

## Datenquellen
- Open Beauty Facts API: Produkt und Inhaltsstoffliste per Barcode, kostenlos, offen.
- COSING / EU-Kosmetikverordnung: lokal als `assets/data/ingredient_reference.json`, erzeugt mit `tool/update_ingredient_data.dart`.
- Mikroplastik-Liste (Beat the Microbead): eingelesen mit `tool/parse_microplastics_list.dart`.

## Aufbau `lib/`
- `main.dart`: Einstieg.
- `screens/`: `scan_screen.dart` (Kamera, Barcode), `product_screen.dart` (Produkt, Ampel, Zusammenfassung).
- `services/`: `open_beauty_facts_service.dart` (API), `ingredient_classifier.dart` (Ampel-Logik).
- `models/`: `product.dart`, `ingredient_rating.dart`.
- `data/`: Referenzlisten (`ingredient_reference.dart`, `known_safe_ingredients.dart`, `keyword_flags.dart`, `emerging_concerns.dart`).

## Ampel-Logik
- Grün: bekannt unbedenklich. Gelb: Duftstoff-Allergen bzw. eingeschränkt. Orange: Annex IV bis VI mit Auflagen. Rot: verboten bzw. CMR-eingestuft. Blau: Mikroplastik.
- Regulatorische, keine toxikologische Bewertung.

## Build und Deployment
- Android: `flutter run` auf dem eigenen Handy (USB-Debugging).
- Web: Zweig `gh-pages` vorhanden.
- Tests: nur ein Widget-Test (`test/widget_test.dart`), keine CI.

## Repo
- `Kassiopia83/Code-Scanner`, öffentlich, Hauptzweig `master`.

## Offene Punkte
- ⚠️ offen: Ob der Web-Prototyp über GitHub Pages veröffentlicht ist und unter welcher Adresse.
- ⚠️ offen: README nennt nur Android, Web-Plattform fehlt dort.
- ⚠️ offen: `docs/setup-installation.md` ist veraltet (Flutter und Android Studio sind inzwischen installiert).
