// Simple Dart script to demonstrate note app functionality
// This can be run with just the Dart VM, no Flutter required

// Simple Note model
class Note {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Note copyWith({String? title, String? content}) {
    return Note(
      id: this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: this.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

// Simple in-memory note repository
class NoteRepository {
  final List<Note> _notes = [];

  List<Note> getAllNotes() {
    return List.from(_notes);
  }

  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (_) {
      return null;
    }
  }

  void addNote(Note note) {
    _notes.add(note);
  }

  bool updateNote(Note updatedNote) {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index >= 0) {
      _notes[index] = updatedNote;
      return true;
    }
    return false;
  }

  bool deleteNote(String id) {
    final initialLength = _notes.length;
    _notes.removeWhere((note) => note.id == id);
    return _notes.length < initialLength;
  }
}

// Simple note service
class NoteService {
  final NoteRepository _repository;
  int _idCounter = 0;

  NoteService(this._repository);

  String _generateId() {
    _idCounter++;
    return 'note-$_idCounter';
  }

  List<Note> getAllNotes() {
    return _repository.getAllNotes()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Note? getNoteById(String id) {
    return _repository.getNoteById(id);
  }

  Note createNote({String title = '', String content = ''}) {
    final note = Note(
      id: _generateId(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _repository.addNote(note);
    return note;
  }

  bool updateNote(Note note) {
    return _repository.updateNote(note);
  }

  bool deleteNote(String id) {
    return _repository.deleteNote(id);
  }
}

void main() {
  print('=== Note Taking App Demo ===');
  
  final repository = NoteRepository();
  final service = NoteService(repository);

  // Create some sample notes
  print('
Creating sample notes...');
  final note1 = service.createNote(
    title: 'Shopping List',
    content: 'Milk
Eggs
Bread
Cheese',
  );
  print('Created note: ${note1.id} - ${note1.title}');

  service.createNote(
    title: 'Meeting Notes',
    content: 'Discuss project timeline and resource allocation',
  );
  
  service.createNote(
    title: 'Ideas',
    content: '1. Mobile app for note taking
2. Cloud sync feature
3. Dark mode theme',
  );

  // List all notes
  print('
Listing all notes:');
  final notes = service.getAllNotes();
  for (final note in notes) {
    print('${note.id} - ${note.title} - Last updated: ${note.updatedAt}');
  }

  // Get a specific note
  print('
Retrieving a specific note:');
  final retrievedNote = service.getNoteById(note1.id);
  if (retrievedNote != null) {
    print('Note ID: ${retrievedNote.id}');
    print('Title: ${retrievedNote.title}');
    print('Content: ${retrievedNote.content}');
    print('Created: ${retrievedNote.createdAt}');
    print('Updated: ${retrievedNote.updatedAt}');
  }

  // Update a note
  print('
Updating a note:');
  if (retrievedNote != null) {
    final updatedNote = retrievedNote.copyWith(
      content: 'Milk
Eggs
Bread
Cheese
Butter
Apples',
    );
    service.updateNote(updatedNote);
    print('Note updated: ${updatedNote.id} - ${updatedNote.title}');
  }

  // View the updated note
  print('
Viewing updated note:');
  final afterUpdate = service.getNoteById(note1.id);
  if (afterUpdate != null) {
    print('Content: ${afterUpdate.content}');
    print('Updated: ${afterUpdate.updatedAt}');
  }

  // Delete a note
  print('
Deleting a note:');
  final deleted = service.deleteNote(note1.id);
  print('Note deleted: $deleted');

  // List remaining notes
  print('
Remaining notes:');
  final remainingNotes = service.getAllNotes();
  for (final note in remainingNotes) {
    print('${note.id} - ${note.title}');
  }

  print('
Demo completed.');
}
