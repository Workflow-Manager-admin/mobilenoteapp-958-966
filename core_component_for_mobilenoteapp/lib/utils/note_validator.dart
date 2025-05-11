/// Utility class for validating note data
class NoteValidator {
  /// Maximum allowed length for note title
  static const int maxTitleLength = 100;
  
  /// Maximum allowed length for note content
  static const int maxContentLength = 10000;

  // PUBLIC_INTERFACE
  /// Validates a note title
  /// Returns null if valid, or an error message if invalid
  static String? validateTitle(String? title) {
    if (title == null) {
      return null; // Null titles are allowed (converted to empty)
    }
    
    if (title.length > maxTitleLength) {
      return 'Title exceeds maximum length of $maxTitleLength characters';
    }
    
    return null; // Title is valid
  }

  // PUBLIC_INTERFACE
  /// Returns null if valid, or an error message if invalid
  static String? validateContent(String? content) {
  /// Validates note content
    if (content == null) {
      return null; // Null content is allowed (converted to empty)
    }
    
    if (content.length > maxContentLength) {
      return 'Content exceeds maximum length of $maxContentLength characters';
    }
    
    return null; // Content is valid
  }

  // PUBLIC_INTERFACE
  /// Checks if a note would be considered empty
  /// Returns true if both title and content are empty or null
  static bool isEmptyNote(String? title, String? content) {
    final effectiveTitle = title ?? '';
    final effectiveContent = content ?? '';
    
    return effectiveTitle.trim().isEmpty && effectiveContent.trim().isEmpty;
  }

  // PUBLIC_INTERFACE
  /// Generate a default title based on content
  /// Useful for notes that have content but no title
  static String generateDefaultTitle(String content, {int maxLength = 30}) {
    if (content.isEmpty) {
      return '';
    }
    
    // Remove line breaks for title generation
    final singleLine = content.replaceAll('
', ' ').trim();
    
    // If content is short enough, use it as is
    if (singleLine.length <= maxLength) {
      return singleLine;
    }
    
    // Otherwise, truncate and add ellipsis
    return '${singleLine.substring(0, maxLength - 3)}...';
  }

  // PUBLIC_INTERFACE
  /// Counts the number of words in a text
  static int countWords(String text) {
    if (text.trim().isEmpty) {
      return 0;
    }
    
    // Split by whitespace and count non-empty items
    return text.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
  }

  // PUBLIC_INTERFACE
  /// Calculates estimated reading time in minutes
  static double estimateReadingTime(String text, {int wordsPerMinute = 200}) {
    final wordCount = countWords(text);
    return wordCount / wordsPerMinute;
  }
}
