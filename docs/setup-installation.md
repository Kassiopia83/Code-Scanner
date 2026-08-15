# Installationsanleitung (Windows)

Ziel: Flutter-Entwicklungsumgebung für Android auf diesem Rechner einrichten. Aktuell (Stand dieses Setups) sind Flutter, Android Studio und Java **noch nicht** installiert.

## 1. Android Studio installieren

1. Herunterladen: https://developer.android.com/studio
2. Installer ausführen, Standardoptionen übernehmen
3. Beim ersten Start: "Standard"-Setup wählen → lädt Android SDK, Android SDK Platform-Tools und einen Android Virtual Device (AVD/Emulator) automatisch mit herunter
4. Java wird von Android Studio als eingebettetes JDK mitgeliefert — eine separate Java-Installation ist normalerweise **nicht** nötig

## 2. Flutter SDK installieren

1. Herunterladen: https://docs.flutter.dev/get-started/install/windows
2. ZIP an einen Ort **ohne Leerzeichen im Pfad** entpacken, z.B. `C:\src\flutter` (nicht unter `OneDrive\Dokumente`, das kann bei Flutter zu Sync-/Pfadproblemen führen)
3. `C:\src\flutter\bin` zur `PATH`-Umgebungsvariable hinzufügen (Windows-Suche → "Umgebungsvariablen bearbeiten")
4. Neues Terminal öffnen, prüfen: `flutter --version`
5. `flutter doctor` ausführen — zeigt an, was noch fehlt (z.B. Android-Lizenzen akzeptieren, fehlende Komponenten)
6. Fehlende Android-Lizenzen akzeptieren: `flutter doctor --android-licenses`

## 3. Android-Gerät zum Testen

Zwei Optionen:

- **Physisches Android-Handy** (empfohlen, da die App eh dafür gedacht ist):
  - Entwickleroptionen aktivieren (Einstellungen → Über das Telefon → 7x auf "Build-Nummer" tippen)
  - USB-Debugging aktivieren (Einstellungen → Entwickleroptionen)
  - Handy per USB verbinden, Verbindung auf dem Handy bestätigen
  - Prüfen: `flutter devices` sollte das Handy anzeigen
- **Android Emulator** (in Android Studio unter "Device Manager" ein virtuelles Gerät anlegen)

## 4. Projekt erzeugen

Sobald Flutter installiert ist, im neuen Repo-Ordner:

```
flutter create --org com.piavogt.codecheckapp --platforms=android .
flutter pub add mobile_scanner http
flutter run
```

(Das Flutter-Projektgerüst wurde hier noch nicht erzeugt, da `flutter create` ein installiertes Flutter SDK voraussetzt.)

## Prüfen, ob alles passt

```
flutter doctor -v
```

Sollte für Android keine roten Kreuze mehr zeigen (gelbe Hinweise, z.B. zu Chrome/VS Code, sind für dieses Projekt unkritisch, da wir nur Android brauchen).
