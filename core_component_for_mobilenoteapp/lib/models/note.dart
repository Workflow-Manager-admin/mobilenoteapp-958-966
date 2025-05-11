import 'dart:convert';

/// Note model class for representing individual notes in the application
class Note {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;

  // PUBLIC_INTERFACE
  /// Constructor for creating a Note instance
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // PUBLIC_INTERFACE
  /// Create a new note with default values
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

  // PUBLIC_INTERFACE
  /// Create a Note from JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // PUBLIC_INTERFACE
  /// Convert Note to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // PUBLIC_INTERFACE
  /// Create a copy of the note with updated fields
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
