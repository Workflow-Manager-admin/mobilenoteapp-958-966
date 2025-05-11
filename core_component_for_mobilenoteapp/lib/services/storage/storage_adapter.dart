/// Abstract interface for storage adapters
abstract class StorageAdapter {
  /// Store a value with the given key
  Future<bool> setValue(String key, String value);
  
  /// Retrieve a value for the given key
  Future<String?> getValue(String key);
  
  /// Store a list of strings with the given key
  Future<bool> setValues(String key, List<String> values);
  
  /// Retrieve a list of strings for the given key
  Future<List<String>?> getValues(String key);
  
  /// Remove a value with the given key
  Future<bool> removeValue(String key);
  
  /// Clear all stored values
  Future<bool> clear();
}

/// In-memory implementation of StorageAdapter for testing or standalone usage
class InMemoryStorageAdapter implements StorageAdapter {
  final Map<String, dynamic> _storage = {};
  
  @override
  Future<bool> setValue(String key, String value) async {
    _storage[key] = value;
    return true;
  }
  
  @override
  Future<String?> getValue(String key) async {
    return _storage[key] as String?;
  }
  
  @override
  Future<bool> setValues(String key, List<String> values) async {
    _storage[key] = values;
    return true;
  }
  
  @override
  Future<List<String>?> getValues(String key) async {
    final value = _storage[key];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return null;
  }
  
  @override
  Future<bool> removeValue(String key) async {
    return _storage.remove(key) != null;
  }
  
  @override
  Future<bool> clear() async {
    _storage.clear();
    return true;
  }
}

/// File-based implementation of StorageAdapter
/// This is a basic implementation that uses files for storage
class FileStorageAdapter implements StorageAdapter {
  final String _basePath;
  
  FileStorageAdapter(this._basePath);
  
  String _getFilePath(String key) {
    // Convert key to a valid filename
    final sanitizedKey = key.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return '$_basePath/$sanitizedKey.txt';
  }
  
  // Note: These methods would normally use dart:io for file access
  // But for demo purposes, they're just placeholders
  
  @override
  Future<bool> setValue(String key, String value) async {
    // In a real implementation, this would write to a file
    print('Would write "$value" to file: ${_getFilePath(key)}');
    return true;
  }
  
  @override
  Future<String?> getValue(String key) async {
    // In a real implementation, this would read from a file
    print('Would read from file: ${_getFilePath(key)}');
    return null;
  }
  
  @override
  Future<bool> setValues(String key, List<String> values) async {
    // In a real implementation, this would write the list to a file
    print('Would write ${values.length} values to file: ${_getFilePath(key)}');
    return true;
  }
  
  @override
  Future<List<String>?> getValues(String key) async {
    // In a real implementation, this would read the list from a file
    print('Would read values from file: ${_getFilePath(key)}');
    return null;
  }
  
  @override
  Future<bool> removeValue(String key) async {
    // In a real implementation, this would delete the file
    print('Would delete file: ${_getFilePath(key)}');
    return true;
  }
  
  @override
  Future<bool> clear() async {
    // In a real implementation, this would delete all files in the directory
    print('Would delete all files in directory: $_basePath');
    return true;
  }
}
