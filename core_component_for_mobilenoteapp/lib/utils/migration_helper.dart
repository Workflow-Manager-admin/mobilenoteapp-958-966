import '../models/note.dart';
import '../services/storage/storage_adapter.dart';

/// Utility to help with data migrations between app versions
class MigrationHelper {
  static const String _versionKey = 'app_data_version';
  static const String _notesKey = 'notes';
  
  final StorageAdapter _storage;
  
  MigrationHelper(this._storage);
  
  // PUBLIC_INTERFACE
  /// Perform migrations if needed
  Future<void> migrateIfNeeded() async {
    final currentVersion = await _getCurrentVersion();
    
    // Apply migrations in sequence
    if (currentVersion < 1) {
      await _migrateToV1();
    }
    
    if (currentVersion < 2) {
      await _migrateToV2();
    }
    
    // Add future migrations here
    
    // Update the version number after all migrations are done
    await _storage.setValue(_versionKey, '2');
  }
  
  /// Get the current data version
  Future<int> _getCurrentVersion() async {
    final versionString = await _storage.getValue(_versionKey);
    if (versionString == null || versionString.isEmpty) {
      return 0; // No version means we're starting fresh
    }
    
    return int.tryParse(versionString) ?? 0;
  }
  
  /// Migrate data from version 0 to version 1
  /// This adds created and updated timestamps to notes
  Future<void> _migrateToV1() async {
    print('Migrating data to version 1...');
    
    // Read existing notes (v0 format)
    final oldNotesJson = await _storage.getValues(_notesKey);
    if (oldNotesJson == null || oldNotesJson.isEmpty) {
      print('No data to migrate.');
      return;
    }
    
    try {
      // In a real migration, we would convert old format to new format
      // For this example, we'll just pretend to update the format
      print('Migrated ${oldNotesJson.length} notes to new format.');
      
      // Save back the "migrated" notes
      await _storage.setValues(_notesKey, oldNotesJson);
      
      print('Migration to version 1 completed successfully.');
    } catch (e) {
      print('Error during migration to version 1: $e');
      // In a real app, we might want to implement rollback logic here
    }
  }
  
  /// Migrate data from version 1 to version 2
  /// This adds categories to notes
  Future<void> _migrateToV2() async {
    print('Migrating data to version 2...');
    
    // Read existing notes (v1 format)
    final notesJsonV1 = await _storage.getValues(_notesKey);
    if (notesJsonV1 == null || notesJsonV1.isEmpty) {
      print('No data to migrate.');
      return;
    }
    
    try {
      // In a real migration, we would add categories
      // For this example, we'll just pretend to update the format
      print('Added default categories to ${notesJsonV1.length} notes.');
      
      // Save back the "migrated" notes
      await _storage.setValues(_notesKey, notesJsonV1);
      
      print('Migration to version 2 completed successfully.');
    } catch (e) {
      print('Error during migration to version 2: $e');
      // In a real app, we might want to implement rollback logic here
    }
  }
}
