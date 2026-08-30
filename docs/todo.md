# To-Do

- [ ] Mikroplastik-Fix an echtem Produkt verifizieren: prüfen, dass ein Inhaltsstoff mit reiner Mikroplastik-Einstufung (ohne CMR-Grund) in der Produkt-Zusammenfassung unter "Mikroplastik enthalten" erscheint und **nicht** mehr unter "Krebserregend / potenziell krankmachend" ([ingredient_classifier.dart](../lib/services/ingredient_classifier.dart), [product_screen.dart](../lib/screens/product_screen.dart)). Aktuell nicht testbar, da `openbeautyfacts.org` ausgefallen ist — sobald der Server wieder erreichbar ist, mit einem bekannten Produkt nachprüfen (z.B. eines mit Polyethylene/Nylon in der Zutatenliste).
- [ ] App im eigenen Portfolio aufführen.

## Fachlich / Datenqualität

- [ ] INCI-Namensvarianten/Synonyme beim Abgleich Inhaltsstoff ↔ Referenzliste behandeln (z.B. Groß-/Kleinschreibung wird schon normalisiert, aber unterschiedliche Schreibweisen/Synonyme desselben Stoffs noch nicht) — siehe [docs/data-sources.md](data-sources.md#offene-fragen-für-später).
- [ ] Update-Rhythmus für die lokale COSING-Referenzliste festlegen (EU-Kosmetikverordnung wird gelegentlich novelliert).

## UX

- [ ] Fallback für "Produkt nicht gefunden" ausbauen: aktuell nur Fehlermeldung, in den Docs war zusätzlich ein Hinweis "manuell erfassen?" vorgesehen ([open_beauty_facts_service.dart](../lib/services/open_beauty_facts_service.dart)).

## Tests / Infrastruktur

- [ ] Tests für die Klassifizierungslogik ergänzen ([ingredient_classifier.dart](../lib/services/ingredient_classifier.dart)) — aktuell existiert nur ein einzelner Widget-Test ([test/widget_test.dart](../test/widget_test.dart)), der nur prüft, ob der Scan-Screen angezeigt wird.
- [ ] CI-Workflow einrichten, der `flutter analyze` und `flutter test` automatisch laufen lässt (aktuell kein `.github/workflows` vorhanden).
- [ ] [docs/setup-installation.md](setup-installation.md) aktualisieren — Flutter/Android Studio sind inzwischen installiert, die Doku sagt noch "noch nicht installiert".
