import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/main.dart';

void main() {
  testWidgets('App should start and show Splash Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ExpenseTrackerApp());

    // Verify that Splash screen is displayed
    expect(find.text('Expense Tracker'), findsOneWidget);

    // Allow the timer to complete to avoid 'timersPending' error in test
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
