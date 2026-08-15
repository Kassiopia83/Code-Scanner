# Datenquellen

## 1. Produkt- und Inhaltsstoffdaten: Open Beauty Facts

- https://world.openbeautyfacts.org/data
- Kostenlose, offene, crowdgesourcte Datenbank (Schwesterprojekt von Open Food Facts), >100.000 Kosmetikprodukte, 170 Länder
- API: `GET https://world.openbeautyfacts.org/api/v2/product/{barcode}.json`
- Liefert u.a. Produktname, Marke, Inhaltsstoffliste (oft als INCI-String), Bilder
- Keine Authentifizierung nötig
- Einschränkung: Datenqualität schwankt (Crowdsourcing), nicht jedes Produkt ist erfasst — Fallback/Fehlerfall im UI einplanen ("Produkt nicht gefunden, manuell erfassen?")

## 2. Risiko-Einstufung der Inhaltsstoffe

CodeCheck bewertet Inhaltsstoffe über eine eigene, redaktionell von einem wissenschaftlichen Team gepflegte Datenbank (>14.000 Stoffe, Kriterien u.a. Gesundheit, Umwelt, Tierwohl). Diese Datenbank ist proprietär und nicht öffentlich zugänglich — sie kann nicht 1:1 nachgebaut werden.

Realistische Grundlage für eine eigene, transparente Einstufung:

- **COSING** (EU-Kommission, kostenlos): https://ec.europa.eu/growth/tools-databases/cosing/
  - Enthält Funktion, Zulassungsstatus, Auflagen/Warnhinweise je Inhaltsstoff
  - Enthält die Anhänge II (verbotene Stoffe) und III (Stoffe mit Einschränkungen) der EU-Kosmetikverordnung (EG) Nr. 1223/2009
  - CSV-Export über data.europa.eu verfügbar
- **EU-Liste der 26 (bzw. seit 2023 erweitert: 80+) deklarationspflichtigen Duftstoff-Allergene** — gut geeignet für eine "gelbe" Kategorie (nicht verboten, aber allergen-relevant)
- Optional später: SCCS-Gutachten (Scientific Committee on Consumer Safety) für Einzelfallbegründungen bei umstrittenen Stoffen

### Vorschlag für ein einfaches, transparentes Ampel-Modell (MVP)

| Farbe | Kriterium |
|---|---|
| Rot | Stoff steht auf EU-Anhang II (verboten) oder ist trotz Verbot/Auflage im Produkt gelistet |
| Gelb | Stoff steht auf EU-Anhang III (Einschränkungen/Auflagen) oder ist deklarationspflichtiges Duftstoff-Allergen |
| Grün | Stoff ist in COSING gelistet, ohne Einschränkung |
| Grau | Stoff nicht in der lokalen Referenzliste gefunden (unbekannt statt automatisch "unbedenklich") |

Wichtig: Das ist eine **regulatorische**, keine **toxikologische** Bewertung — sprich, sie zeigt, was rechtlich in der EU eingeschränkt/verboten ist, nicht zwingend eine wissenschaftliche Risikoeinschätzung wie bei CodeCheck. Das sollte im UI transparent kommuniziert werden (Quellenangabe + kurzer Disclaimer), auch um keine falschen Sicherheits- oder Gefahrenversprechen zu machen.

### Offene Fragen (für später)

- Reicht ein selbst gepflegtes JSON/SQLite mit COSING-Auszug (nur Stoffe aus Anhang II/III + Allergenliste), oder soll die komplette COSING-Liste importiert werden?
- Update-Rhythmus für die Referenzliste (EU-Verordnung wird gelegentlich novelliert)
- Umgang mit INCI-Namensvarianten/Synonymen beim Abgleich Produkt-Inhaltsstoff ↔ Referenzliste
