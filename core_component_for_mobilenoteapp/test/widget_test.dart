import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_component_for_mobilenoteapp/main.dart';
import 'package:core_component_for_mobilenoteapp/screens/notes_list_screen.dart';

void main() {
  testWidgets('App loads notes list screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify that the notes list screen is displayed
    expect(find.byType(NotesListScreen), findsOneWidget);
  });

  testWidgets('App bar has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify the app bar title
    expect(find.text('My Notes'), findsOneWidget);
  });
}
