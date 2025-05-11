import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final NoteService _noteService = NoteService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _isEditing = true;
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = _isEditing
            ? widget.note!.title != _titleController.text ||
                widget.note!.content != _contentController.text
            : _titleController.text.isNotEmpty || _contentController.text.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    // Don't save if nothing changed (for editing) or if both fields are empty (for new notes)
    if (!_hasChanges ||
        (!_isEditing && _titleController.text.isEmpty && _contentController.text.isEmpty)) {
      Navigator.pop(context, false);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isEditing) {
        // Update existing note
        final updatedNote = widget.note!.copyWith(
          title: _titleController.text,
          content: _contentController.text,
        );
        await _noteService.updateNote(updatedNote);
      } else {
        // Create new note
        await _noteService.createNote(
          title: _titleController.text,
          content: _contentController.text,
        );
      }

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate changes were made
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save note: ${e.toString()}')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('DISCARD'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Note' : 'New Note'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isLoading ? null : _saveNote,
              tooltip: 'Save',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    const Divider(),
                    Expanded(
                      child: TextField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          hintText: 'Write your note here...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
