---
typ: dynamisch
bereich: produkt
produkt: Code-Scanner
quelle: beides
aktualisiert: 2026-10-31
---

# Entscheidungen Code-Scanner

## Übersicht
Wichtige Produkt- und Technikentscheidungen mit Grund. Claude Code nutzt die Liste, damit verworfene Ansätze nicht erneut vorgeschlagen werden. Neue Entscheidungen oben in der Tabelle ergänzen. Datum aus der Commit-Historie, wo nicht anders belegt.

| Datum | Entscheidung | Verworfen | Grund | Quelle |
|---|---|---|---|---|
| 2026-10-31 | Backlog-Priorität: Mikroplastik-Fix, COSING-Update-Rhythmus, INCI-Synonyme, Tests, Fallback „nicht gefunden“, CI, Setup-Doku | – | Entscheidung Pia | Interview |
| 2026-10-31 | Nur für die eigene Nutzung, keine Vermarktung | Veröffentlichung für andere | Ziel ist Ersatz für CodeCheck bei Pia | Interview |
| 2026-08-30 | Web-Plattform zusätzlich zu Android | Nur Android | Klickbarer Prototyp für das Portfolio | Commit |
| 2026-08-30 | Robustere Produktabfrage (Retry, User-Agent) | – | Timeout-Fehler beim Live-Test | Commit, Portfolio |
| 2026-08-16 | Persistente Detail-Box je Inhaltsstoff | Tooltip | Quelle je Einstufung dauerhaft sichtbar | Commit, README |
| 2026-08-16 | Orange-Stufe für Annex IV bis VI mit konkreten Auflagen; bedingte Annex-II-Verbote kennzeichnen (Petrolatum-Fall) | Pauschales Verbot | Einstufung sonst irreführend | Commit |
| 2026-08-16 | Gesundheitsfokussierte Zusammenfassung pro Produkt | Allgemeine „Auffälligkeiten“ | Verständlicher für die Nutzung | Commit |
| 2026-08-16 | Blaue Stufe für Mikroplastik (Beat the Microbead) | – | Eigenes Kriterium neben EU-Regelwerk | Commit |
| 2026-08-16 | Echter COSING-CSV-Import als Referenz | Handgepflegte Startliste | Vollständigere, offizielle Datenbasis | Commit |
| 2026-08-16 | Regulatorische Einstufung auf Basis EU-Daten (COSING, Kosmetikverordnung) | Toxikologische bzw. eigene wissenschaftliche Bewertung wie CodeCheck | CodeCheck nutzt eine proprietäre, redaktionell gepflegte Datenbank, nicht nachbaubar | README, Portfolio, `data-sources.md` |
| 2026-08-16 | Open Beauty Facts als Produktdatenquelle | Kostenpflichtige Datenbanken | Kostenlos, offen, Barcode-basiert | README |
| 2026-08-15 | Flutter mit `mobile_scanner` (ML Kit) | – | ⚠️ offen | Commit |
| 2026-08-15 | Out of Scope: Nutzerkonten, Cloud-Historie, iOS, Erfassen fehlender Produkte | – | MVP schlank halten | README |
