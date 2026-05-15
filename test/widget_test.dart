import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/main.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:expense_tracker/providers/settings_provider.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App should start and show Splash Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProxyProvider<AuthProvider, TransactionProvider>(
            create: (context) => TransactionProvider(),
            update: (context, auth, previous) =>
                previous!..updateUserId(auth.user?.uid),
          ),
          ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ],
        child: const ExpenseTrackerApp(),
      ),
    );

    // Verify that Splash screen is displayed
    expect(find.text('Expense Tracker'), findsOneWidget);

    // Allow the timer to complete to avoid 'timersPending' error in test
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
