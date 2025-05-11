// This file demonstrates how to use the note service without requiring the Flutter framework
// It can be used to understand the core functionality of the note-taking app

import 'dart:convert';
import '../models/note.dart';

/// A simplified version of the note service for demonstration
class DemoNoteService {
  // In-memory storage for notes
  final Map<String, Note> _notesMap = {};
  
  /// Get all notes
  List<Note> getNotes() {
    return _notesMap.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// Get a note by ID
  Note? getNoteById(String id) {
    return _notesMap[id];
  }

  /// Create a new note
  Note createNote({String title = '', String content = ''}) {
    final now = DateTime.now();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    final note = Note(
      id: id,
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
    
    _notesMap[id] = note;
    return note;
  }

  /// Update an existing note
  Note updateNote(Note note) {
    if (!_notesMap.containsKey(note.id)) {
      throw Exception('Note not found');
    }
    
    final updatedNote = note.copyWith(
      title: note.title,
      content: note.content,
    );
    
    _notesMap[note.id] = updatedNote;
    return updatedNote;
  }

  /// Delete a note by ID
  void deleteNote(String id) {
    _notesMap.remove(id);
  }
  
  /// Print all notes (for demonstration)
  void printAllNotes() {
    print('--- All Notes ---');
    
    if (_notesMap.isEmpty) {
      print('No notes available');
      return;
    }
    
    for (final note in getNotes()) {
      print('ID: ${note.id}');
      print('Title: ${note.title.isEmpty ? "(No title)" : note.title}');
      print('Content: ${note.content.substring(0, note.content.length > 30 ? 30 : note.content.length)}${note.content.length > 30 ? "..." : ""}');
      print('Created: ${note.createdAt}');
      print('Updated: ${note.updatedAt}');
      print('---');
    }
  }

  /// Convert note to JSON string (for demonstration)
  String noteToJson(Note note) {
    return jsonEncode(note.toJson());
  }
  
  /// Create note from JSON string (for demonstration)
  Note noteFromJson(String json) {
    return Note.fromJson(jsonDecode(json));
  }
}

/// Example of using the note service
void main() {
  final demoService = DemoNoteService();
  
  print('Creating notes...');
  final note1 = demoService.createNote(
    title: 'Shopping List',
    content: 'Milk, Eggs, Bread'
  );
  
  demoService.createNote(
    title: 'Meeting Notes',
    content: 'Discuss project timeline and resource allocation'
  );
  
  demoService.createNote(
    content: 'Remember to call mom'
  );
  
  // Print all notes
  demoService.printAllNotes();
  
  // Update a note
  print('
Updating note...');
  final updatedNote = note1.copyWith(
    content: 'Milk, Eggs, Bread, Cheese, Vegetables'
  );
  demoService.updateNote(updatedNote);
  
  // Print all notes again to see the update
  demoService.printAllNotes();
  
  // Delete a note
  print('
Deleting note...');
  demoService.deleteNote(note1.id);
  
  // Print all notes again to confirm deletion
  demoService.printAllNotes();
  
  // Demonstrate JSON serialization
  print('
JSON serialization example:');
  final note = demoService.createNote(
    title: 'JSON Example',
    content: 'This note will be converted to JSON'
  );
  
  final jsonString = demoService.noteToJson(note);
  print('Note as JSON: $jsonString');
  
  final noteFromJson = demoService.noteFromJson(jsonString);
  print('Note recovered from JSON:');
  print('ID: ${noteFromJson.id}');
  print('Title: ${noteFromJson.title}');
  print('Content: ${noteFromJson.content}');
}
