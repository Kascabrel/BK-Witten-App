# frontend

# BK-Witten-App-Projekt (G-3)

![Flutter](https://img.shields.io/badge/Flutter-2.10-blue?logo=flutter)  
![Dart](https://img.shields.io/badge/Dart-2.19-blue?logo=dart)

## Beschreibung

Die **BK-Witten-App** ist eine mobile Flutter-Anwendung für Schüler des BK Witten. Die App liefert
wichtige Informationen für den Schulalltag:

- **Lageplan** – Schulgebäudeplan
- **Parkplätze** – verfügbare Parkplätze
- **Schulaufbau** – Aufbau der Schule
- **Ansprechpartner** – wichtige Kontakte
- **Lehrer** – Liste der Lehrkräfte mit Kürzel
- **Sozialhelfer** – Sozialhelfer der Schule
- **Schulleitung** – Leitung der Schule
- **Wichtige Infos über die Schule** – Zusammenfassung der Schulwebseite
- **Stundenplan** – Stundenplan inkl. Ausfällen
- **Wichtige Events** – wichtige Termine
- **Elternsprechtag** – Termine für Elternsprechstunden
- **Ferienzeit** – Ferienübersicht
- **Blockzeiten** – Unterrichtszeiten in Blöcken
- **Feiertage** – gesetzliche Feiertage

---

## Hauptfunktionen

1. Intuitive Navigation für schnellen Zugriff auf alle Informationen.
2. Anzeige der Lehrkräfte mit Kürzel und Kontaktinformationen.
3. Benachrichtigungen bei Stundenplanänderungen oder Ausfällen.
4. Kalender für wichtige Events und Feiertage.
5. Details zur Schulstruktur und wichtige Kontakte.

---

## Voraussetzungen für die Entwicklung

- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.0
- [Dart](https://dart.dev/get-dart) ≥ 2.19
- IDE: **Android Studio** oder **Visual Studio Code** mit Flutter-Plugin
- Android- oder iOS-Emulator bzw. physisches Gerät zum Testen

---

## Installation (lokale Entwicklung)

1. **Repository klonen:**

```bash
git clone https://github.com/dein-benutzername/BK-Witten-App-Projekt.git
cd BK-Witten-App-Projekt
````

2. **Abhängigkeiten installiere:**

```bash
flutter pub get
```

3. **App auf Emulator oder Gerät starten:**

```bash
    flutter run
```

4. **App für Produktion bauen:**

````bash
flutter build apk   # für Android
flutter build ios   # für iOS
````

5. **Projektstruktur**

````agsl
lib/
├─ main.dart          # Einstiegspunkt der App
├─ screens/           # Alle Seiten der App (z.B. Stundenplan, Lehrer, Events)
├─ widgets/           # Wiederverwendbare Komponenten
├─ models/            # Datenmodelle
├─ services/          # API- oder lokale Datenservices
└─ utils/             # Hilfsfunktionen

````

## code convention

- Dateinamen und Klassen in camelCase.
- Wiederverwendbare Widgets im Ordner /widgets.
- const für unveränderliche Widgets verwenden (Performance).
- Kommentare auf Englisch oder Deutsch, je nach Logik des Codes.