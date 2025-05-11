// A simple test utility for the note service
// This can be run with just Dart, without requiring Flutter

import '../models/note.dart';
import '../services/storage/storage_adapter.dart';

// A mock storage implementation for testing
class MockStorage implements StorageAdapter {
  final Map<String, dynamic> _data = {};

  @override
  Future<bool> setValue(String key, String value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<String?> getValue(String key) async {
    return _data[key] as String?;
  }

  @override
  Future<bool> setValues(String key, List<String> values) async {
    _data[key] = values;
    return true;
  }

  @override
  Future<List<String>?> getValues(String key) async {
    final value = _data[key];
    if (value is List<String>) {
      return value;
    }
    return null;
  }

  @override
  Future<bool> removeValue(String key) async {
    return _data.remove(key) != null;
  }

  @override
  Future<bool> clear() async {
    _data.clear();
    return true;
  }
}

// A simplified note service for testing
class TestNoteService {
  final StorageAdapter _storage;
  final String _notesKey = 'test_notes';
  int _idCounter = 0;

  TestNoteService(this._storage);

  Future<String> _generateId() async {
    _idCounter++;
    return 'note-$_idCounter';
  }

  Future<Note> createNote({String title = '', String content = ''}) async {
    final now = DateTime.now();
    final id = await _generateId();
    
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

  Future<List<Note>> getAllNotes() async {
    return await _getAllNotes();
  }

  Future<Note?> getNoteById(String id) async {
    final notes = await _getAllNotes();
    try {
      return notes.firstWhere((note) => note.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateNote(Note updatedNote) async {
    final notes = await _getAllNotes();
    final index = notes.indexWhere((note) => note.id == updatedNote.id);
    
    if (index == -1) {
      return false;
    }
    
    notes[index] = updatedNote;
    await _saveAllNotes(notes);
    
    return true;
  }

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

  // For testing purposes, simplified storage
  Future<List<Note>> _getAllNotes() async {
    final List<Note> notes = [];
    final storedNotes = await _storage.getValues(_notesKey);
    
    if (storedNotes == null) {
      return [];
    }
    
    for (final noteData in storedNotes) {
      // Very simplified parsing for test purposes
      final id = noteData.split('::')[0];
      final title = noteData.split('::')[1];
      final content = noteData.split('::')[2];
      final timestamp = DateTime.now(); // Just for testing
      
      notes.add(Note(
        id: id,
        title: title,
        content: content,
        createdAt: timestamp,
        updatedAt: timestamp,
      ));
    }
    
    return notes;
  }

  Future<void> _saveAllNotes(List<Note> notes) async {
    final List<String> serializedNotes = [];
    
    for (final note in notes) {
      // Very simplified serialization for test purposes
      serializedNotes.add('${note.id}::${note.title}::${note.content}');
    }
    
    await _storage.setValues(_notesKey, serializedNotes);
  }
}

// Test runner function
void runTests() {
  print('=== Running Note Service Tests ===');
  
  final mockStorage = MockStorage();
  final noteService = TestNoteService(mockStorage);
  
  // Test 1: Creating a note
  testCreateNote(noteService);
  
  // Test 2: Retrieving notes
  testGetNotes(noteService);
  
  // Test 3: Updating a note
  testUpdateNote(noteService);
  
  // Test 4: Deleting a note
  testDeleteNote(noteService);
  
  print('
All tests completed.');
}

// Test implementations
Future<void> testCreateNote(TestNoteService service) async {
  print('
Test: Creating a note');
  
  final note = await service.createNote(
    title: 'Test Note',
    content: 'This is a test note',
  );
  
  print('- Created note with ID: ${note.id}');
  assert(note.id.isNotEmpty, 'Note ID should not be empty');
  assert(note.title == 'Test Note', 'Note title should match');
  assert(note.content == 'This is a test note', 'Note content should match');
  
  print('✓ Create note test passed');
}

Future<void> testGetNotes(TestNoteService service) async {
  print('
Test: Retrieving notes');
  
  // Create another note
  await service.createNote(
    title: 'Another Note',
    content: 'This is another test note',
  );
  
  final notes = await service.getAllNotes();
  print('- Retrieved ${notes.length} notes');
  
  assert(notes.length >= 2, 'Should have at least 2 notes');
  assert(notes.any((note) => note.title == 'Test Note'), 'First note should be in the list');
  assert(notes.any((note) => note.title == 'Another Note'), 'Second note should be in the list');
  
  print('✓ Get notes test passed');
}

Future<void> testUpdateNote(TestNoteService service) async {
  print('
Test: Updating a note');
  
  final notes = await service.getAllNotes();
  final noteToUpdate = notes.first;
  
  // Copy with updated content
  final updatedNote = Note(
    id: noteToUpdate.id,
    title: noteToUpdate.title,
    content: 'Updated content for the test',
    createdAt: noteToUpdate.createdAt,
    updatedAt: DateTime.now(),
  );
  
  final result = await service.updateNote(updatedNote);
  print('- Update result: $result');
  
  // Retrieve the updated note
  final retrievedNote = await service.getNoteById(noteToUpdate.id);
  
  assert(result, 'Update should return true');
  assert(retrievedNote != null, 'Updated note should exist');
  assert(retrievedNote?.content == 'Updated content for the test', 'Content should be updated');
  
  print('✓ Update note test passed');
}

Future<void> testDeleteNote(TestNoteService service) async {
  print('
Test: Deleting a note');
  
  final notes = await service.getAllNotes();
  final noteToDelete = notes.last;
  
  final result = await service.deleteNote(noteToDelete.id);
  print('- Delete result: $result');
  
  // Try to retrieve the deleted note
  final retrievedNote = await service.getNoteById(noteToDelete.id);
  
  assert(result, 'Delete should return true');
  assert(retrievedNote == null, 'Deleted note should not exist');
  
  // Check that total count decreased
  final remainingNotes = await service.getAllNotes();
  assert(remainingNotes.length == notes.length - 1, 'Should have one less note');
  
  print('✓ Delete note test passed');
}

// Main entry point
void main() async {
  await runTests();
}
