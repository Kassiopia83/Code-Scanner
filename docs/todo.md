---
typ: dynamisch
bereich: produkt
produkt: Code-Scanner
quelle: beides
aktualisiert: 2026-10-31
---

# Backlog und Testbefunde

## Übersicht
Technische Aufgaben und Testbefunde des Code-Scanners, nach Priorität sortiert. Claude Code nutzt die Liste als Arbeitsgrundlage und aktualisiert sie am Ende einer Session. Aufgaben für Pia (testen, entscheiden) stehen nicht hier, sondern in ihrem privaten Vault (`_To Do.md`).

## Offene Aufgaben (nach Priorität)
1. [ ] **Mikroplastik-Fix an echtem Produkt verifizieren:** Ein Inhaltsstoff mit reiner Mikroplastik-Einstufung (ohne CMR-Grund) muss in der Zusammenfassung unter „Mikroplastik enthalten“ erscheinen, nicht unter „Krebserregend / potenziell krankmachend“ ([ingredient_classifier.dart](../lib/services/ingredient_classifier.dart), [product_screen.dart](../lib/screens/product_screen.dart)). Mit einem bekannten Produkt mit Polyethylene oder Nylon prüfen, sobald Open Beauty Facts erreichbar ist.
2. [ ] **Update-Rhythmus für die lokale COSING-Referenzliste festlegen** (EU-Kosmetikverordnung wird gelegentlich novelliert).
3. [ ] **INCI-Namensvarianten und Synonyme** beim Abgleich Inhaltsstoff ↔ Referenzliste behandeln. Groß- und Kleinschreibung wird schon normalisiert, Synonyme noch nicht ([data-sources.md](data-sources.md#offene-fragen-für-später)).
4. [ ] **Tests für die Klassifizierungslogik** ergänzen ([ingredient_classifier.dart](../lib/services/ingredient_classifier.dart)). Bisher nur ein Widget-Test ([test/widget_test.dart](../test/widget_test.dart)).
5. [ ] **Fallback „Produkt nicht gefunden“ ausbauen:** Bisher nur Fehlermeldung, vorgesehen war zusätzlich ein Hinweis „manuell erfassen?“ ([open_beauty_facts_service.dart](../lib/services/open_beauty_facts_service.dart)).
6. [ ] **CI-Workflow** für `flutter analyze` und `flutter test` (bisher kein `.github/workflows`).
7. [ ] **[setup-installation.md](setup-installation.md) aktualisieren:** Flutter und Android Studio sind inzwischen installiert.

## Testbefunde

| Datum | Gerät | Schritte | Erwartet | Tatsächlich | Status |
|---|---|---|---|---|---|
| bis 31.10.2026 | Android-Handy | Produkte in der Drogerie gescannt | Produkt und Inhaltsstoffe werden angezeigt | Kein getestetes Produkt war in der Datenbank vorhanden | offen |
| ⚠️ offen | Android-Handy | Live-Test | Abfrage liefert Ergebnis | Timeout-Fehler | behoben |
| ⚠️ offen | Android-Handy | Produkt mit bestimmtem Inhaltsstoff geprüft | Korrekte Einordnung in der Gesundheits-Zusammenfassung | Inhaltsstoff irreführend eingeordnet | behoben |

## Erledigt
- [x] App im eigenen Portfolio aufgeführt (Seite `Projekte_Code_Scanner.html`).

## Offene Punkte
- ⚠️ offen: Ursache des Drogerie-Befunds. Entweder fehlen die Produkte in Open Beauty Facts, oder der Server war ausgefallen (siehe Aufgabe 1). Solange kein Produkt gefunden wird, ist das Erfolgskriterium „Pia nutzt den Code-Scanner statt CodeCheck“ nicht erreichbar.
