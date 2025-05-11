import '../models/note.dart';
import 'package:uuid/uuid.dart';

/// Utility class for generating sample note data
class MockData {
  static final _uuid = Uuid();
  
  // PUBLIC_INTERFACE
  /// Generate a list of sample notes for testing or demonstration
  static List<Note> getSampleNotes() {
    final now = DateTime.now();
    
    return [
      Note(
        id: _uuid.v4(),
        title: 'Welcome to Note Taking App',
        content: 'This is a sample note to get you started with our app. '
                'You can create, edit, and delete notes as needed.',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Note(
        id: _uuid.v4(),
        title: 'Shopping List',
        content: '- Milk
- Eggs
- Bread
- Fruits
- Vegetables',
        createdAt: now.subtract(const Duration(days: 3, hours: 5)),
        updatedAt: now.subtract(const Duration(days: 3, hours: 5)),
      ),
      Note(
        id: _uuid.v4(),
        title: 'Project Ideas',
        content: '1. Mobile app for tracking expenses
'
                '2. Website for sharing recipes
'
                '3. Smart home automation system',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      Note(
        id: _uuid.v4(),
        title: '',
        content: 'Remember to call mom about the weekend plans.',
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
    ];
  }
  
  // PUBLIC_INTERFACE
  /// Create a single sample note
  static Note getSampleNote() {
    final now = DateTime.now();
    
    return Note(
      id: _uuid.v4(),
      title: 'Sample Note',
      content: 'This is a sample note content.

'
              'You can edit this note to add your own content.',
      createdAt: now.subtract(const Duration(hours: 1)),
      updatedAt: now.subtract(const Duration(hours: 1)),
    );
  }
}
