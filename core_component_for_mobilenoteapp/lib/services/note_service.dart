import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';

/// Service class for handling note storage and operations
class NoteService {
  static const String _notesKey = 'notes';
  final Uuid _uuid = const Uuid();

  // PUBLIC_INTERFACE
  /// Get all notes from storage
  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];
    
    return notesJson
        .map((noteJson) => Note.fromJson(jsonDecode(noteJson)))
        .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); // Sort by most recently updated
  }

  // PUBLIC_INTERFACE
  /// Get a specific note by ID
  Future<Note?> getNoteById(String id) async {
    final notes = await getNotes();
    return notes.firstWhere((note) => note.id == id, orElse: () => throw Exception('Note not found'));
  }

  // PUBLIC_INTERFACE
  /// Save a new note
  Future<Note> createNote({String title = '', String content = ''}) async {
    final note = Note.create(
      id: _uuid.v4(),
      title: title,
      content: content,
    );
    
    final notes = await getNotes();
    notes.add(note);
    await _saveNotes(notes);
    
    return note;
  }

  // PUBLIC_INTERFACE
  /// Update an existing note
  Future<Note> updateNote(Note note) async {
    final notes = await getNotes();
    final index = notes.indexWhere((n) => n.id == note.id);
    
    if (index == -1) {
      throw Exception('Note not found');
    }
    
    // Update with the current timestamp
    final updatedNote = note.copyWith(
      title: note.title,
      content: note.content,
    );
    
    notes[index] = updatedNote;
    await _saveNotes(notes);
    
    return updatedNote;
  }

  // PUBLIC_INTERFACE
  /// Delete a note by ID
  Future<void> deleteNote(String id) async {
    final notes = await getNotes();
    notes.removeWhere((note) => note.id == id);
    await _saveNotes(notes);
  }

  /// Internal method to save notes to SharedPreferences
  Future<void> _saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((note) => jsonEncode(note.toJson())).toList();
    await prefs.setStringList(_notesKey, notesJson);
  }
}
