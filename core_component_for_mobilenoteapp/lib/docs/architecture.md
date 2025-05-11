# Note Taking App Architecture

## Overview

The Note Taking App is structured using a simple layered architecture with the following components:

1. **UI Layer** - Contains screens and widgets
2. **Service Layer** - Contains business logic and data operations
3. **Data Layer** - Contains data models and persistence logic

## Component Diagram

```
┌───────────────────────────────────────────────────┐
│                   UI Layer                        │
│                                                   │
│  ┌───────────────┐  ┌────────────────┐  ┌───────────────┐
│  │ NotesListScreen│  │NoteEditorScreen│  │NoteDetailScreen│
│  └───────────────┘  └────────────────┘  └───────────────┘
└───────────────────────────────────────────────────┘
                       │
                       ▼
┌───────────────────────────────────────────────────┐
│                Service Layer                       │
│                                                   │
│                 ┌────────────┐                    │
│                 │ NoteService │                   │
│                 └────────────┘                    │
└───────────────────────────────────────────────────┘
                       │
                       ▼
┌───────────────────────────────────────────────────┐
│                Data Layer                         │
│                                                   │
│                  ┌────────┐                       │
│                  │  Note  │                       │
│                  └────────┘                       │
│                                                   │
│              ┌──────────────────┐                 │
│              │ SharedPreferences │                │
│              └──────────────────┘                 │
└───────────────────────────────────────────────────┘
```

## Data Flow

1. User interactions in the UI layer call methods on the NoteService
2. NoteService performs operations on the Note model objects
3. NoteService persists notes using SharedPreferences
4. UI is updated with the results from the NoteService

## Key Components

### Models
- **Note**: Represents a single note with properties like id, title, content, createdAt, and updatedAt

### Services
- **NoteService**: Handles CRUD operations for notes and manages persistence

### Screens
- **NotesListScreen**: Displays a list of all notes
- **NoteEditorScreen**: Provides UI for creating and editing notes
- **NoteDetailScreen**: Shows the details of a single note

## Data Persistence

Notes are stored using SharedPreferences in a JSON format. Each note is serialized to JSON, and the list of serialized notes is saved as a string list in SharedPreferences.

## Dependencies

- **shared_preferences**: Used for local storage
- **uuid**: Used for generating unique identifiers for notes
- **intl**: Used for date formatting in the UI
