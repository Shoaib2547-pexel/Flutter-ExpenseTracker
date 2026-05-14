import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _currencySymbol = '\$';

  bool get isDarkMode => _isDarkMode;
  String get currencySymbol => _currencySymbol;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setCurrency(String symbol) {
    _currencySymbol = symbol;
    notifyListeners();
  }
}
