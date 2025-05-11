# Note Taking App

A Flutter-based mobile application for creating, managing, and organizing notes.

## Features

- Create and edit notes with title and content
- View a list of all saved notes
- View note details
- Delete unwanted notes
- Local storage for persistent note saving
- Clean, intuitive user interface

## Project Structure

- `lib/models/` - Data models for the application
  - `note.dart` - The note data model

- `lib/services/` - Services and business logic
  - `note_service.dart` - Service for CRUD operations on notes
  - `storage/` - Storage adapters and persistence utilities

- `lib/screens/` - UI screens
  - `notes_list_screen.dart` - Main screen showing list of notes
  - `note_editor_screen.dart` - Screen for creating and editing notes
  - `note_detail_screen.dart` - Screen for viewing note details

- `lib/utils/` - Utility classes
  - `note_validator.dart` - Validation utilities for notes
  - `migration_helper.dart` - Helper for data migrations

- `lib/standalone/` - Standalone implementation (without Flutter)
  - `note_app_core.dart` - Core note functionality in plain Dart

- `lib/cli/` - Command-line interface
  - `note_app_cli.dart` - CLI for note management

- `lib/docs/` - Documentation
  - `architecture.md` - Architecture overview
  - `api_docs.md` - API documentation
  - `user_guide.md` - User guide
  - `usage_guide.md` - Developer usage guide

- `web_dashboard/` - Simple web dashboard for notes

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

### Running Without Flutter

If Flutter is not available, you can still explore the core functionality:

1. Use `run_standalone.sh` to see a demonstration of the core note functionality
2. View the web dashboard by opening `web_dashboard/index.html` in a browser
3. Run `dart run_demo.dart` to see a simple demo (if Dart is installed)

## Dependencies

- shared_preferences: For local storage
- uuid: For generating unique IDs
- intl: For date formatting

## Future Enhancements

- Cloud synchronization
- Note categories/tags
- Rich text formatting
- Search functionality
- Reminders/notifications
- Dark mode
- Export options (PDF, text file)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
