# 📱 BK-Witten-App-Projekt (G-3)

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue?logo=flutter)  
![Dart](https://img.shields.io/badge/Dart-2.19-blue?logo=dart)

---

## 📖 Beschreibung

Die **BK-Witten-App** ist eine mobile Flutter-Anwendung für Schüler*innen des BK Witten.  
Sie liefert wichtige Informationen für den Schulalltag in einer **übersichtlichen und modernen Benutzeroberfläche**:

- 🏫 **Lageplan** – Schulgebäudeplan
- 🅿️ **Parkplätze** – verfügbare Parkplätze
- 🏢 **Schulaufbau** – Aufbau der Schule
- 📇 **Ansprechpartner** – wichtige Kontakte
- 👩‍🏫 **Lehrer** – Liste der Lehrkräfte mit Kürzeln und Kontakten
- 🤝 **Sozialhelfer** – Unterstützende Fachkräfte
- 👨‍💼 **Schulleitung** – Übersicht der Leitung
- ℹ️ **Allgemeine Infos** – Zusammenfassung der Schulwebseite
- 📅 **Stundenplan** – inkl. Ausfällen und Änderungen
- 🎉 **Wichtige Events** – Termine & Veranstaltungen
- 👪 **Elternsprechtage** – Terminübersicht
- 🏖 **Ferienzeiten** – Ferienübersicht
- 🕒 **Blockzeiten** – Unterrichtszeiten in Blöcken
- 🇩🇪 **Feiertage** – gesetzliche Feiertage

---

## 🚀 Hauptfunktionen

1. **Intuitive Navigation** für schnellen Zugriff auf alle Infos
2. **Lehrkräfte-Übersicht** mit Kürzeln & Kontaktmöglichkeiten
3. **Benachrichtigungen** bei Stundenplanänderungen oder Ausfällen
4. **Kalenderintegration** für Events, Ferien und Feiertage
5. **Schulstruktur & Ansprechpartner** kompakt dargestellt

---

## 🛠 Voraussetzungen für die Entwicklung

- [Flutter SDK](https://flutter.dev/docs/get-started/install) **≥ 3.0**
- [Dart](https://dart.dev/get-dart) **≥ 2.19**
- IDE: **Android Studio** oder **Visual Studio Code** mit Flutter-Plugin
- Android- oder iOS-Emulator **oder** physisches Gerät

---

## 📦 Installation (lokale Entwicklung)

1. **Repository klonen**

```bash
git clone https://github.com/Kascabrel/BK-Witten-App.git
cd BK-Witten-App-Projekt/frontend
```

2. **Abhängigkeiten installieren**

```bash
flutter pub get
```

3. **App starten (Entwicklung)**

```bash
flutter run
```

4. **Produktionsbuild erstellen**

```bash
flutter build apk   # Android
flutter build ios   # iOS
```

---

## 📂 Projektstruktur

```agsl
frontend/lib/
├─ main.dart          # Einstiegspunkt der App
├─ screens/           # Screens/Seiten (z.B. Stundenplan, Lehrer, Events)
├─ widgets/           # Wiederverwendbare UI-Komponenten
├─ models/            # Datenmodelle
├─ services/          # API- / Datenservices
└─ utils/             # Hilfsfunktionen
```

---

## 📐 Code-Konventionen

- **Dateien**: `snake_case.dart` (z. B. `teacher_screen.dart`)
- **Klassen & Methoden**: `UpperCamelCase`
- **Variablen & Funktionen**: `lowerCamelCase`
- **Widgets**: Wiederverwendbare Widgets im Ordner `/widgets`
- **const verwenden** für unveränderliche Widgets (Performance)
- **Kommentare**: auf Englisch oder Deutsch, aber einheitlich

---

## 👥 Beitragende

- Team **Gruppe-3**, BK Witten
- (Steve cabrel Kamguia, ...... Nils, ......Philip, .......Debora )

---

## 📌 ToDos

- [ ] Stundenplan mit API-Anbindung
- [ ] Push-Benachrichtigungen für Änderungen
- [ ] Offline-Modus für Grundfunktionen
- [ ] Hauptsprache auf Deutsch

---


