// This is a standalone implementation of the note app's core functionality
// It can be run with just the Dart SDK, without requiring Flutter

// Note Model
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

  factory Note.create({
    required String id,
    String title = '',
    String content = '',
  }) {
    final now = DateTime.now();
    return Note(
      id: id,
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
  }

  Note copyWith({
    String? title,
    String? content,
  }) {
    return Note(
      id: this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: this.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

// Simple in-memory storage for notes
class InMemoryNoteRepository {
  final Map<String, Note> _notes = {};

  List<Note> getAllNotes() {
    return _notes.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Note? getNoteById(String id) {
    return _notes[id];
  }

  void saveNote(Note note) {
    _notes[note.id] = note;
  }

  bool deleteNote(String id) {
    return _notes.remove(id) != null;
  }
}

// Note Service for business logic
class NoteService {
  final InMemoryNoteRepository _repository;
  int _idCounter = 0;

  NoteService(this._repository);

  String _generateId() {
    _idCounter++;
    return 'note-$_idCounter';
  }

  List<Note> getAllNotes() {
    return _repository.getAllNotes();
  }

  Note? getNoteById(String id) {
    return _repository.getNoteById(id);
  }

  Note createNote({String title = '', String content = ''}) {
    final note = Note.create(
      id: _generateId(),
      title: title,
      content: content,
    );
    _repository.saveNote(note);
    return note;
  }

  Note? updateNote(String id, {String? title, String? content}) {
    final note = _repository.getNoteById(id);
    if (note == null) return null;

    final updatedNote = note.copyWith(
      title: title,
      content: content,
    );
    _repository.saveNote(updatedNote);
    return updatedNote;
  }

  bool deleteNote(String id) {
    return _repository.deleteNote(id);
  }
}

// Command line interface for the note app
class NoteAppCLI {
  final NoteService _service;

  NoteAppCLI(this._service);

  void run() {
    print('=== Note Taking App CLI ===');
    print('Commands:');
    print('  list - List all notes');
    print('  new - Create a new note');
    print('  view [id] - View note details');
    print('  edit [id] - Edit a note');
    print('  delete [id] - Delete a note');
    print('  exit - Exit the application');
    print('');

    // Create some sample notes
    _service.createNote(
      title: 'Welcome!',
      content: 'Welcome to the Note Taking App CLI. This is a sample note.',
    );
    _service.createNote(
      title: 'Shopping List',
      content: '- Milk
- Bread
- Eggs
- Cheese',
    );
    _service.createNote(
      title: 'Meeting Notes',
      content: 'Discuss project timeline and resource allocation',
    );

    print('Sample notes created. Try the "list" command to see them.
');
  }

  void listNotes() {
    final notes = _service.getAllNotes();
    if (notes.isEmpty) {
      print('No notes found.');
      return;
    }

    print('
All Notes:');
    print('--------------------------------------------------');
    for (final note in notes) {
      final title = note.title.isEmpty ? '(Untitled)' : note.title;
      print('ID: ${note.id}');
      print('Title: $title');
      final contentPreview = note.content.length > 30
          ? '${note.content.substring(0, 30)}...'
          : note.content;
      print('Content: $contentPreview');
      print('Last updated: ${_formatDate(note.updatedAt)}');
      print('--------------------------------------------------');
    }
    print('');
  }

  void viewNote(String id) {
    final note = _service.getNoteById(id);
    if (note == null) {
      print('Note not found with ID: $id');
      return;
    }

    print('
Note Details:');
    print('--------------------------------------------------');
    print('ID: ${note.id}');
    print('Title: ${note.title.isEmpty ? "(Untitled)" : note.title}');
    print('Content:');
    print(note.content);
    print('--------------------------------------------------');
    print('Created: ${_formatDate(note.createdAt)}');
    print('Last updated: ${_formatDate(note.updatedAt)}');
    print('');
  }

  Note? createNote() {
    print('
Creating a new note:');
    print('Enter title (press Enter for no title):');
    final title = _readLine();

    print('Enter content:');
    final content = _readLine();

    if (title.isEmpty && content.isEmpty) {
      print('Note creation cancelled - both title and content are empty.');
      return null;
    }

    final note = _service.createNote(title: title, content: content);
    print('Note created with ID: ${note.id}
');
    return note;
  }

  Note? editNote(String id) {
    final note = _service.getNoteById(id);
    if (note == null) {
      print('Note not found with ID: $id');
      return null;
    }

    print('
Editing note with ID: $id');
    print('Current title: ${note.title}');
    print('Enter new title (press Enter to keep current):');
    final title = _readLine();

    print('Current content:');
    print(note.content);
    print('Enter new content (press Enter to keep current):');
    final content = _readLine();

    final updatedNote = _service.updateNote(
      id,
      title: title.isEmpty ? null : title,
      content: content.isEmpty ? null : content,
    );

    if (updatedNote != null) {
      print('Note updated successfully.
');
    } else {
      print('Failed to update note.
');
    }
    return updatedNote;
  }

  bool deleteNote(String id) {
    final note = _service.getNoteById(id);
    if (note == null) {
      print('Note not found with ID: $id');
      return false;
    }

    final title = note.title.isEmpty ? '(Untitled)' : note.title;
    print('
Are you sure you want to delete the note "$title"? (y/n)');
    final confirm = _readLine().toLowerCase();

    if (confirm == 'y' || confirm == 'yes') {
      final deleted = _service.deleteNote(id);
      if (deleted) {
        print('Note deleted successfully.
');
      } else {
        print('Failed to delete note.
');
      }
      return deleted;
    } else {
      print('Deletion cancelled.
');
      return false;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_pad(date.month)}-${_pad(date.day)} ${_pad(date.hour)}:${_pad(date.minute)}';
  }

  String _pad(int number) {
    return number.toString().padLeft(2, '0');
  }

  String _readLine() {
    // In a real CLI app, this would read input from stdin
    // but for demonstration, we'll just return an empty string
    return '';
  }
}

// Demo function showing how to use the note app components
void main() {
  // Create repository and service
  final repository = InMemoryNoteRepository();
  final service = NoteService(repository);
  
  // Create some sample notes
  final note1 = service.createNote(
    title: 'First Note',
    content: 'This is my first note content.'
  );
  
  service.createNote(
    title: 'Shopping List',
    content: '- Milk
- Eggs
- Bread'
  );
  
  service.createNote(
    title: '',
    content: 'Untitled note with just content.'
  );
  
  // List all notes
  print('All Notes:');
  final allNotes = service.getAllNotes();
  for (final note in allNotes) {
    print('- ${note.id}: ${note.title} (${note.updatedAt})');
  }
  
  // Update a note
  final updatedNote = service.updateNote(
    note1.id,
    title: 'Updated First Note',
    content: 'This content has been updated!'
  );
  print('
Updated Note:');
  print(updatedNote);
  
  // Delete a note
  final deleted = service.deleteNote(note1.id);
  print('
Note deleted: $deleted');
  
  // List notes after deletion
  print('
Remaining Notes:');
  final remainingNotes = service.getAllNotes();
  for (final note in remainingNotes) {
    print('- ${note.id}: ${note.title}');
  }
  
  // Create a CLI instance (in a real app, we would run this)
  print('
Creating CLI instance:');
  final cli = NoteAppCLI(service);
  cli.run();
  print('Note app core functionality demonstration completed.');
}
