// A simple standalone test file for the Note model
// This can be run with dart test without requiring Flutter

import '../models/note.dart';

void main() {
  // Test Note creation
  testNoteCreation();
  
  // Test Note JSON conversion
  testNoteJsonConversion();
  
  // Test Note copyWith function
  testNoteCopyWith();
  
  print('All tests completed.');
}

void testNoteCreation() {
  print('
=== Testing Note Creation ===');
  final note = Note.create(
    id: 'test-id-1',
    title: 'Test Title',
    content: 'Test Content',
  );
  
  assert(note.id == 'test-id-1', 'ID should match');
  assert(note.title == 'Test Title', 'Title should match');
  assert(note.content == 'Test Content', 'Content should match');
  assert(note.createdAt is DateTime, 'createdAt should be DateTime');
  assert(note.updatedAt is DateTime, 'updatedAt should be DateTime');
  
  print('✓ Note creation test passed');
}

void testNoteJsonConversion() {
  print('
=== Testing Note JSON Conversion ===');
  final originalNote = Note.create(
    id: 'test-id-2',
    title: 'JSON Test',
    content: 'Testing JSON conversion',
  );
  
  final json = originalNote.toJson();
  assert(json['id'] == 'test-id-2', 'JSON id should match');
  assert(json['title'] == 'JSON Test', 'JSON title should match');
  assert(json['content'] == 'Testing JSON conversion', 'JSON content should match');
  assert(json['createdAt'] is String, 'JSON createdAt should be a string');
  assert(json['updatedAt'] is String, 'JSON updatedAt should be a string');
  
  final decodedNote = Note.fromJson(json);
  assert(decodedNote.id == originalNote.id, 'Decoded note ID should match original');
  assert(decodedNote.title == originalNote.title, 'Decoded note title should match original');
  assert(decodedNote.content == originalNote.content, 'Decoded note content should match original');
  assert(decodedNote.createdAt.toString() == originalNote.createdAt.toString(), 
    'Decoded note createdAt should match original');
  assert(decodedNote.updatedAt.toString() == originalNote.updatedAt.toString(), 
    'Decoded note updatedAt should match original');
  
  print('✓ Note JSON conversion test passed');
}

void testNoteCopyWith() {
  print('
=== Testing Note copyWith ===');
  final originalNote = Note.create(
    id: 'test-id-3',
    title: 'Original Title',
    content: 'Original Content',
  );
  
  // Small delay to ensure updatedAt will be different
  Future.delayed(const Duration(milliseconds: 10), () {});
  
  final updatedTitle = originalNote.copyWith(title: 'Updated Title');
  assert(updatedTitle.id == originalNote.id, 'ID should not change');
  assert(updatedTitle.title == 'Updated Title', 'Title should be updated');
  assert(updatedTitle.content == originalNote.content, 'Content should not change');
  assert(updatedTitle.createdAt == originalNote.createdAt, 'createdAt should not change');
  assert(updatedTitle.updatedAt != originalNote.updatedAt, 'updatedAt should change');
  
  final updatedContent = originalNote.copyWith(content: 'Updated Content');
  assert(updatedContent.id == originalNote.id, 'ID should not change');
  assert(updatedContent.title == originalNote.title, 'Title should not change');
  assert(updatedContent.content == 'Updated Content', 'Content should be updated');
  assert(updatedContent.createdAt == originalNote.createdAt, 'createdAt should not change');
  assert(updatedContent.updatedAt != originalNote.updatedAt, 'updatedAt should change');
  
  final updatedBoth = originalNote.copyWith(
    title: 'New Title', 
    content: 'New Content'
  );
  assert(updatedBoth.title == 'New Title', 'Title should be updated');
  assert(updatedBoth.content == 'New Content', 'Content should be updated');
  
  print('✓ Note copyWith test passed');
}
