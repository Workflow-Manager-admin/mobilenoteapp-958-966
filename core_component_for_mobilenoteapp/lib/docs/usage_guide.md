# Note Taking App - Usage Guide

This document provides examples of how to use the Note Taking App's core functionality in your code.

## Basic Usage

### Initializing the Note Service

```dart
import 'package:core_component_for_mobilenoteapp/services/note_service.dart';

void main() async {
  // Create an instance of the note service
  final noteService = NoteService();
  
  // Now you can use the service to manage notes
}
```

### Creating a New Note

```dart
// Create a new note with title and content
final note = await noteService.createNote(
  title: 'Meeting Notes',
  content: '- Discuss project timeline
- Review budget
- Assign tasks'
);

// Create a note with just content
final quickNote = await noteService.createNote(
  content: 'Remember to call John about the project'
);
```

### Retrieving Notes

```dart
// Get all notes
final allNotes = await noteService.getNotes();

// Get a specific note by ID
final note = await noteService.getNoteById('note-id');
if (note != null) {
  print('Note Title: ${note.title}');
  print('Note Content: ${note.content}');
}
```

### Updating a Note

```dart
// First get the note
final note = await noteService.getNoteById('note-id');
if (note != null) {
  // Create an updated version of the note
  final updatedNote = note.copyWith(
    title: 'Updated Title',
    content: 'This content has been updated'
  );
  
  // Save the updated note
  await noteService.updateNote(updatedNote);
}
```

### Deleting a Note

```dart
// Delete a note by ID
await noteService.deleteNote('note-id');
```

## Integration with Flutter UI

### Displaying a List of Notes

```dart
class _NotesListScreenState extends State<NotesListScreen> {
  final NoteService _noteService = NoteService();
  List<Note> _notes = [];
  
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }
  
  Future<void> _loadNotes() async {
    final notes = await _noteService.getNotes();
    setState(() {
      _notes = notes;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return ListTile(
          title: Text(note.title.isEmpty ? 'Untitled' : note.title),
          subtitle: Text(note.content),
          onTap: () {
            // Navigate to note details
          },
        );
      },
    );
  }
}
```

### Creating a Note in a Form

```dart
class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final NoteService _noteService = NoteService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  
  Future<void> _saveNote() async {
    await _noteService.createNote(
      title: _titleController.text,
      content: _contentController.text
    );
    
    Navigator.pop(context, true); // Return with refresh flag
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Note')),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          Expanded(
            child: TextField(
              controller: _contentController,
              decoration: InputDecoration(hintText: 'Content'),
              maxLines: null,
            ),
          ),
          ElevatedButton(
            onPressed: _saveNote,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
```

## Advanced Usage

### Working with Timestamps

```dart
// Get notes created today
final allNotes = await noteService.getNotes();
final today = DateTime.now();
final todayStart = DateTime(today.year, today.month, today.day);

final todayNotes = allNotes.where((note) => 
  note.createdAt.isAfter(todayStart)).toList();

// Sort notes by creation date (newest first)
allNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
```

### Searching Notes

```dart
Future<List<Note>> searchNotes(String query) async {
  final allNotes = await noteService.getNotes();
  final queryLower = query.toLowerCase();
  
  return allNotes.where((note) => 
    note.title.toLowerCase().contains(queryLower) || 
    note.content.toLowerCase().contains(queryLower)
  ).toList();
}
```

### Error Handling

```dart
try {
  final note = await noteService.getNoteById('note-id');
  // Process note
} catch (e) {
  print('Error retrieving note: $e');
  // Handle the error appropriately
}
```

## Extending the Note Model

If you need to add additional fields to the Note model:

```dart
class ExtendedNote extends Note {
  final String category;
  final bool isFavorite;
  
  ExtendedNote({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.category,
    required this.isFavorite,
  }) : super(
    id: id,
    title: title,
    content: content,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['category'] = category;
    json['isFavorite'] = isFavorite;
    return json;
  }
  
  factory ExtendedNote.fromJson(Map<String, dynamic> json) {
    return ExtendedNote(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      category: json['category'],
      isFavorite: json['isFavorite'],
    );
  }
}
```
