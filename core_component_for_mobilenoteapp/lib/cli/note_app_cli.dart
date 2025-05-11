import 'dart:io';
import '../models/note.dart';
import '../services/storage/storage_adapter.dart';

// A simple Note service that works with storage adapter
class CliNoteService {
  final StorageAdapter _storage;
  final String _notesKey = 'notes_cli';
  
  CliNoteService(this._storage);
  
  // Create a new note
  Future<Note> createNote({String title = '', String content = ''}) async {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();
    
    final note = Note(
      id: id,
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
    
    final notes = await _getAllNotes();
    notes.add(note);
    await _saveAllNotes(notes);
    
    return note;
  }
  
  // Get all notes
  Future<List<Note>> getNotes() async {
    final notes = await _getAllNotes();
    // Sort by last updated (newest first)
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return notes;
  }
  
  // Get a note by ID
  Future<Note?> getNoteById(String id) async {
    final notes = await _getAllNotes();
    try {
      return notes.firstWhere((note) => note.id == id);
    } catch (_) {
      return null;
    }
  }
  
  // Update a note
  Future<Note?> updateNote(Note note) async {
    final notes = await _getAllNotes();
    final index = notes.indexWhere((n) => n.id == note.id);
    
    if (index == -1) {
      return null;
    }
    
    // Update the note with current timestamp
    final updatedNote = note.copyWith(
      title: note.title,
      content: note.content,
    );
    
    notes[index] = updatedNote;
    await _saveAllNotes(notes);
    
    return updatedNote;
  }
  
  // Delete a note
  Future<bool> deleteNote(String id) async {
    final notes = await _getAllNotes();
    final initialLength = notes.length;
    
    notes.removeWhere((note) => note.id == id);
    
    if (notes.length == initialLength) {
      // No note was removed
      return false;
    }
    
    await _saveAllNotes(notes);
    return true;
  }
  
  // Helper method to get all notes from storage
  Future<List<Note>> _getAllNotes() async {
    try {
      final notesJson = await _storage.getValues(_notesKey);
      
      if (notesJson == null || notesJson.isEmpty) {
        return [];
      }
      
      return notesJson.map((json) => _deserializeNote(json)).toList();
    } catch (e) {
      print('Error reading notes: $e');
      return [];
    }
  }
  
  // Helper method to save all notes to storage
  Future<void> _saveAllNotes(List<Note> notes) async {
    try {
      final notesJson = notes.map((note) => _serializeNote(note)).toList();
      await _storage.setValues(_notesKey, notesJson);
    } catch (e) {
    }
      print('Error saving notes: $e');
  }
  
  // Serialize a note to JSON string
  String _serializeNote(Note note) {
    return note.toJson().toString();
  }
  
  // Deserialize a note from JSON string
  Note _deserializeNote(String json) {
    try {
      // This is a simplified version for the CLI demo
      // A real implementation would properly parse the JSON
      final parts = json.split(',');
      final id = parts[0].split(':')[1].trim();
      final title = parts[1].split(':')[1].trim();
      final content = parts[2].split(':')[1].trim();
      
      return Note.create(
        id: id,
        title: title,
        content: content,
      );
    } catch (e) {
      print('Error parsing note: $e');
      return Note.create(
        id: DateTime.now().toString(),
        title: 'Error',
        content: 'Failed to parse note data',
      );
    }
  }
}

// CLI interface for the note app
void main() {
  print('=== Note Taking App CLI ===');
  print('This is a demonstration of the note app functionality.');
  print('In a real environment, you would be able to interact with this CLI.');
  print('Available commands would include:');
  print('  - list: List all notes');
  print('  - new: Create a new note');
  print('  - view [id]: View note details');
  print('  - edit [id]: Edit a note');
  print('  - delete [id]: Delete a note');
  print('  - exit: Exit the application');
  print('
This CLI version uses an in-memory storage adapter.');
  print('All data will be lost when the program exits.');
  
  // Initialize the storage and service
  final storage = InMemoryStorageAdapter();
  final noteService = CliNoteService(storage);
  
  // Create some sample notes
  runSampleOperations(noteService);
}

// Run some sample operations to demonstrate functionality
Future<void> runSampleOperations(CliNoteService service) async {
  print('
Creating sample notes...');
  
  // Create some sample notes
  await service.createNote(
    title: 'Welcome to the Note Taking App',
    content: 'This is a sample note created by the CLI demo.'
  );
  
  await service.createNote(
    title: 'Shopping List',
    content: '- Milk
- Bread
- Eggs
- Cheese'
  );
  
  final note3 = await service.createNote(
    title: 'Meeting Notes',
    content: 'Discuss project timeline and resource allocation'
  );
  
  // List all notes
  print('
Listing all notes:');
  final notes = await service.getNotes();
  for (final note in notes) {
    print('ID: ${note.id}');
    print('Title: ${note.title}');
    print('Content: ${note.content.substring(0, note.content.length > 30 ? 30 : note.content.length)}${note.content.length > 30 ? "..." : ""}');
    print('Updated: ${note.updatedAt}');
    print('---');
  }
  
  // Update a note
  print('
Updating a note:');
  final updatedNote = note3.copyWith(
    content: 'Discuss project timeline and resource allocation
- Added new timeline
- Requested additional resources'
  );
  await service.updateNote(updatedNote);
  
  // View the updated note
  print('
Viewing updated note:');
  final retrievedNote = await service.getNoteById(note3.id);
  if (retrievedNote != null) {
    print('ID: ${retrievedNote.id}');
    print('Title: ${retrievedNote.title}');
    print('Content: ${retrievedNote.content}');
    print('Created: ${retrievedNote.createdAt}');
    print('Updated: ${retrievedNote.updatedAt}');
  }
  
  // Delete a note
  print('
Deleting a note:');
  await service.deleteNote(note3.id);
  
  // List notes after deletion
  print('
Listing notes after deletion:');
  final remainingNotes = await service.getNotes();
  for (final note in remainingNotes) {
    print('- ${note.title}');
  }
  
  print('
CLI demonstration completed.');
}
