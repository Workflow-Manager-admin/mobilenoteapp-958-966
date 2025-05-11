# Note Taking App API Documentation

## Note Model

### Properties

| Property  | Type     | Description                               |
|-----------|----------|-------------------------------------------|
| id        | String   | Unique identifier for the note            |
| title     | String   | Title of the note                        |
| content   | String   | Main text content of the note            |
| createdAt | DateTime | Timestamp when the note was created      |
| updatedAt | DateTime | Timestamp when the note was last updated |

### Methods

#### `Note.create({required String id, String title = '', String content = ''})`
Factory constructor to create a new note with default values.

#### `Note.fromJson(Map<String, dynamic> json)`
Factory constructor to create a Note from a JSON object.

#### `Map<String, dynamic> toJson()`
Convert a Note object to a JSON object.

#### `Note copyWith({String? title, String? content})`
Create a copy of the note with updated fields.

## NoteService

### Methods

#### `Future<List<Note>> getNotes()`
Retrieves all saved notes from storage.

**Returns:** A list of notes sorted by last updated date (newest first).

#### `Future<Note?> getNoteById(String id)`
Retrieves a specific note by its ID.

**Parameters:**
- `id`: The unique identifier of the note to retrieve.

**Returns:** The note with the specified ID, or throws an exception if not found.

#### `Future<Note> createNote({String title = '', String content = ''})`
Creates a new note with the specified title and content.

**Parameters:**
- `title`: (Optional) The title of the note.
- `content`: (Optional) The content of the note.

**Returns:** The newly created note.

#### `Future<Note> updateNote(Note note)`
Updates an existing note.

**Parameters:**
- `note`: The note object with updated fields.

**Returns:** The updated note.

#### `Future<void> deleteNote(String id)`
Deletes a note with the specified ID.

**Parameters:**
- `id`: The unique identifier of the note to delete.

## Usage Examples

### Creating a Note

```dart
final noteService = NoteService();
final note = await noteService.createNote(
  title: 'Shopping List',
  content: '- Milk
- Eggs
- Bread'
);
```

### Retrieving All Notes

```dart
final noteService = NoteService();
final notes = await noteService.getNotes();
for (final note in notes) {
  print('${note.title}: ${note.content}');
}
```

### Updating a Note

```dart
final noteService = NoteService();
final note = await noteService.getNoteById('note-id');
if (note != null) {
  final updatedNote = note.copyWith(
    title: 'Updated Title',
    content: 'Updated content'
  );
  await noteService.updateNote(updatedNote);
}
```

### Deleting a Note

```dart
final noteService = NoteService();
await noteService.deleteNote('note-id');
```
