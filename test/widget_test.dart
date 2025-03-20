// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:giccenroquezon/main.dart'; // Keep this import since we’re testing MyAppInitializer

void main() {
  testWidgets('DatabaseLocationPicker displays correctly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester
        .pumpWidget(MyAppInitializer()); // Use MyAppInitializer directly

    // Wait for the initialization future to complete (1 second delay in MyAppInitializer)
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify that the DatabaseLocationPicker screen is displayed
    expect(find.text('Select Database Location'), findsOneWidget);
    expect(
        find.text('Please choose a folder where the database will be stored.'),
        findsOneWidget);
    expect(find.text('Browse'), findsOneWidget);

    // Optionally, simulate tapping the "Browse" button (requires mocking file_picker)
    // For now, we’ll just check the UI presence
  });
}
