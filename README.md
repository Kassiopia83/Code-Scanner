# Kosmetik-Scanner (Arbeitstitel)

Eigene Android-App als Ersatz für die App "CodeCheck": Barcode eines Kosmetikprodukts scannen, Liste der Inhaltsstoffe anzeigen, mit farbiger Einstufung (grün/gelb/rot) für möglicherweise riskante Inhaltsstoffe.

Persönliches Projekt, unabhängig vom Leistungsradar-Repo.

## MVP-Scope

**In Scope**
- Barcode scannen (Kamera)
- Produkt- und Inhaltsstoffliste per Barcode abrufen (Open Beauty Facts API)
- Inhaltsstoffe farblich einstufen (grün = unbedenklich, gelb = mit Einschränkung/Auflage, rot = verboten/stark eingeschränkt in der EU)
- Lokale Anzeige, kein Login nötig

**Out of Scope (später)**
- Eigene Nutzerkonten / Historie in der Cloud
- iOS-Version
- Eigene wissenschaftliche Bewertung wie bei CodeCheck (deren Ampel basiert auf einer proprietären, redaktionell gepflegten Datenbank von >14.000 Inhaltsstoffen – das lässt sich nicht 1:1 nachbauen, siehe [docs/data-sources.md](docs/data-sources.md))
- Barcode-Erfassung für fehlende Produkte / eigener Beitrag an Open Beauty Facts

## Tech-Stack

- **Flutter** (Dart) für die Android-App
- Barcode-Scan: Paket `mobile_scanner` (nutzt ML Kit)
- Datenquelle: [Open Beauty Facts API](https://world.openbeautyfacts.org/data) (kostenlos, offen, Barcode-basiert)
- Risiko-Einstufung: eigenes, lokales Regelwerk auf Basis öffentlicher EU-Daten (COSING/Kosmetikverordnung), siehe [docs/data-sources.md](docs/data-sources.md)

## Status

Projektgerüst angelegt, noch kein Code. Nächste Schritte siehe [docs/setup-installation.md](docs/setup-installation.md).
