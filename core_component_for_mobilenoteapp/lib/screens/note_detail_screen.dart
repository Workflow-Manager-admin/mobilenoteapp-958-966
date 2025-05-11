import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import 'note_editor_screen.dart';

class NoteDetailScreen extends StatefulWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final NoteService _noteService = NoteService();
  Note? _note;
  bool _isLoading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    setState(() {
      _isLoading = true;
      _error = false;
    });

    try {
      final note = await _noteService.getNoteById(widget.noteId);
      setState(() {
        _note = note;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = true;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load note: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _deleteNote() async {
    try {
      await _noteService.deleteNote(widget.noteId);
      if (mounted) {
        Navigator.pop(context, true); // Return to list with refresh flag
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete note: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmation() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: Text('Are you sure you want to delete "${_note?.title.isEmpty ?? true ? 'Untitled Note' : _note!.title}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteNote();
              },
              child: const Text('DELETE', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (!_isLoading && !_error && _note != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToEdit(),
              tooltip: 'Edit',
            ),
          if (!_isLoading && !_error && _note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _showDeleteConfirmation,
              tooltip: 'Delete',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error || _note == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to load note',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNote,
              child: const Text('Retry'),
            ),
          ],
        ),
      );

    }
    // Note loaded successfully
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _note!.title.isEmpty ? 'Untitled Note' : _note!.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Created: ${DateFormat('MMM d, yyyy HH:mm').format(_note!.createdAt)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.update, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Updated: ${DateFormat('MMM d, yyyy HH:mm').format(_note!.updatedAt)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const Divider(height: 32),
          if (_note!.content.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'No content',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            Text(
              _note!.content,
              style: const TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }

  Future<void> _navigateToEdit() async {
    if (_note == null) return;
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(note: _note),
      ),
    );

    if (result == true) {
      _loadNote(); // Reload note if changes were made
    }
  }
}
