---
typ: statisch
bereich: produkt
produkt: Code-Scanner
quelle: beides
aktualisiert: 2026-10-31
---

# Produktsteckbrief Code-Scanner

## Übersicht
Kurzprofil des Code-Scanners. Claude Code nutzt das Dokument, um Feature-Ideen und Änderungen gegen Ziel und Scope zu prüfen. Technik siehe [tech-stack.md](tech-stack.md), offene Aufgaben siehe [todo.md](todo.md).

## Problem
- Apps zur Bewertung von Kosmetik-Inhaltsstoffen sind kostenpflichtig oder werbefinanziert; kostenlose Versionen begrenzen die Zahl der Scans.

## Ziel
- Kostenlose, werbefreie Alternative zu CodeCheck für die eigene Nutzung: Barcode scannen, Inhaltsstoffe transparent einordnen, mit offen einsehbarer Quelle je Einstufung.

## Zielgruppe
- Nur Pia selbst. Keine Vermarktung, keine Veröffentlichung im Store geplant.

## Erfolgskriterium
- Pia nutzt den Code-Scanner statt CodeCheck.

## Scope (MVP)
- Barcode per Kamera scannen.
- Produkt und Inhaltsstoffliste über die Open Beauty Facts API abrufen.
- Inhaltsstoffe per Ampel einordnen (regulatorisch auf Basis EU-Daten, nicht toxikologisch).
- Lokal, ohne Login.

## Out of Scope
- Nutzerkonten und Cloud-Historie.
- iOS.
- Eigene wissenschaftliche Bewertung wie bei CodeCheck.
- Erfassen fehlender Produkte bzw. Beiträge an Open Beauty Facts.

## Status
- MVP-Kernflow funktioniert (Scan, Abruf, Ampel, Detail-Box, Zusammenfassung).
- Entwicklung sporadisch, privat.

## Rollen
- Pia: Product Managerin (Scope, fachliche Entscheidungen, Test, Abnahme).
- Claude Code: technische Umsetzung.
