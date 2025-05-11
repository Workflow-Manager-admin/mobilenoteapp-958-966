# Mobile Note Taking App

A Flutter-based note taking application with a note editor and local saving functionality.

## Features

- Create, read, update, and delete notes
- Rich text editor for note content
- Local storage for persistently saving notes
- Clean, intuitive UI

## Project Structure

- `lib/models/` - Data models for the application
- `lib/screens/` - UI screens for different parts of the app
- `lib/services/` - Business logic and services for data handling
- `lib/utils/` - Utility classes and helper functions

## Getting Started

1. Ensure you have Flutter installed on your system
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Dependencies

- shared_preferences: For local storage
- uuid: For generating unique IDs
- intl: For date formatting

## How to Use

1. Launch the app to see your list of notes
2. Tap the floating action button (+) to create a new note
3. Tap on a note to view its details
4. Use the edit button to modify a note
5. Use the delete button to remove a note