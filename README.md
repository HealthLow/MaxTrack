WARNING:GEMINI WAS USED IN THE EARLY STAGES AS I DIDN'T KNOW HOW TO USE FLUTTER AND DART
THIS IS A PERSONAL LEARNING EXERCISE BUT ALSO AN APP THAT I ACTUALLY USE PERSONALLY.
AI SUMMARY OF ORIGINAL IDEA OF APP
----------
# MaxTrack - Offline Calorie Tracker

MaxTrack is a lightweight, fully offline-first calorie and nutrition tracking application built with Flutter. It allows users to manage a personal database of food items and ingredients and log their daily intake without needing an internet connection.

## Features

- **100% Offline:** All data is stored locally on your device using an `sqflite` database. No cloud account or internet connection is required.
- **Food & Ingredient Database:** Add custom food items and reusable ingredients with detailed nutritional information (calories, protein, carbs, fat).
- **Food Logging:** A simple interface to search for existing foods and log them for a specific day.
- **Dynamic Search:** Real-time search functionality to quickly find items in your database.
- **Cross-Platform:** Built from a single codebase to run on both Android and iOS.

## Current Development Status

The project is in the early stages of development. The core database structure and the UI for adding new food items are complete. The next focus is on implementing the food logging and history views.

### Implemented Features
- [x] Local `sqflite` database setup with `food_items` and `log_entries` tables.
- [x] Home screen with a clear navigation menu.
- [x] A dedicated screen to add new food items or ingredients.
- [x] Form with validation for food data entry.
- [x] Confirmation dialogs for a smooth user experience.
- [x] Basic UI for the "Log Food" search screen.

### Next Steps
1.  Implement live database search on the "Log Food" screen.
2.  Build the UI to display a list of all food items.
3.  Add camera support to attach images to food items.
4.  Implement the import/export functionality for user profiles.

## Technical Stack

- **Framework:** Flutter
- **Language:** Dart
- **Local Database:** `sqflite`
- **Logging:** `logger` package
- **App Icons:** `flutter_launcher_icons`

## Getting Started

To run this project locally, you will need to have the Flutter SDK installed.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/HealthLow/MaxTrack.git
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd MaxTrack/maxtrack
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the app:**
    ```bash
    flutter run
    ```

## Automated Tasks

This project includes VS Code tasks for common operations.

- **`Build Android APK (Release)`:** Compiles the application into a release-ready APK.
- **`Clean Android Gradle Cache`:** Cleans the native Android build cache to resolve stubborn build issues.

---
*This project is being developed as a personal learning exercise.*
----------
AS SAID IN EVEN THE AI SUMMARY, THIS IS A PERSONAL LEARNING EXERCISE BUT ALSO AN APP THAT I ACTUALLY USE PERSONALLY.
