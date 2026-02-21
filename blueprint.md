
# FitTrack Mini - Blueprint

## Overview

FitTrack Mini is a modern, offline-first fitness tracking application for Flutter. It is designed to be a lightweight, intuitive, and visually appealing app that helps users monitor their physical activities without needing an internet connection. All data is stored locally on the device, ensuring user privacy and instant access.

## Key Features

*   **Offline-First:** Fully functional without an internet connection.
*   **Local Data Storage:** Uses the high-performance Hive database to store all user data securely on the device.
*   **Intuitive UI:** A clean, modern, and easy-to-navigate user interface built with Material Design 3 principles.
*   **Core Metrics:** Tracks key fitness metrics, including:
    *   Steps
    *   Calories Burned
    *   Active Time
    *   Distance
*   **Activity Logging:** Allows users to manually log various activities like walking, running, cycling, and more.
*   **Dashboard:** A central hub displaying daily progress, key stats, and recent activities.
*   **History:** A detailed log of all past activities, allowing users to review their performance over time.
*   **Analytics:** Visual charts and summaries providing insights into weekly, monthly, and yearly performance.
*   **Data Management:** Users can:
    *   Export their data to a JSON backup file.
    *   Import data from a backup file.
    *   Delete all their data.

## Design and Style

*   **Theme:** A dual-theme system (light and dark) based on a modern color palette with Teal as the primary accent.
*   **Typography:** Uses the `poppins` font from Google Fonts for a clean and readable text style.
*   **Iconography:** Utilizes Material Design icons for clear and consistent navigation.
*   **Layout:** Employs cards, responsive grids, and clean spacing to create a visually balanced and intuitive layout.

## Architecture

*   **State Management:** Uses `provider` for managing app-wide state, such as the theme.
*   **Routing:** Leverages the `go_router` package for a declarative and robust navigation system.
*   **Database:** Implements `Hive` for all local data storage, managed through a centralized `DatabaseService`.
*   **Folder Structure:** Follows a clean, feature-first structure:
    *   `lib/models/`: Contains all data models (e.g., `Activity`).
    *   `lib/services/`: Includes services like `DatabaseService`.
    *   `lib/screens/`: Holds all the main screens of the app.
    *   `lib/widgets/`: Contains reusable UI components.

## Implemented Changes & Fixes (Current Session)

*   **Offline-First Conversion:** Successfully migrated the app to a fully offline architecture using the Hive database.
*   **UI/UX Enhancements:**
    *   **Dashboard:** Redesigned the dashboard to be more intuitive and visually appealing.
    *   **Add Activity Screen:** Simplified the activity logging process by removing the manual distance input and calculating it based on activity type and duration.
    *   **Analytics Screen:** Fixed bottom overflow issues by making the layout scrollable and fixed the data source to use live data from the database.
*   **Navigation:**
    *   **Back Button:** Fixed the back navigation logic. The app now navigates to the "Dashboard" tab from other tabs instead of closing, providing a more intuitive user experience.
*   **Code Cleanup:**
    *   **Removed Unnecessary Files:** Deleted all backend-related files, old UI screens (`splash_screen.dart`), and Firebase configurations (`.idx/mcp.json`, `GEMINI.md`).
    *   **Removed Firebase Dependencies:** Cleaned up `pubspec.yaml` and other files to remove all Firebase-related code and dependencies.
