#!/bin/bash

# This script demonstrates how to run the standalone Dart implementation
# of the note taking app core functionality

# Check if Dart is installed
if command -v dart &> /dev/null; then
    echo "Running standalone note app core implementation..."
    dart lib/standalone/note_app_core.dart
else
    echo "Dart is not installed or not in PATH."
    echo ""
    echo "This is a demonstration of how to run the standalone implementation."
    echo "If Dart was installed, the command would be:"
    echo "  dart lib/standalone/note_app_core.dart"
    echo ""
    echo "To view the code, please check:"
    echo "  lib/standalone/note_app_core.dart"
fi

echo ""
echo "Note app structure:"
echo "  - lib/models/note.dart: Data model for notes"
echo "  - lib/services/note_service.dart: Service for managing notes"
echo "  - lib/screens/: UI screens (Flutter)"
echo "  - lib/standalone/: Standalone Dart implementation"
echo "  - lib/docs/: Architecture and API documentation"
echo "  - lib/demo/: Demo implementation"
