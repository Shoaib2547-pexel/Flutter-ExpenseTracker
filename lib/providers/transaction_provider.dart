import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  String? _userId;
  StreamSubscription? _subscription;

  void updateUserId(String? userId) {
    if (_userId != userId) {
      _userId = userId;
      _transactions.clear();
      _subscription?.cancel();
      
      if (_userId != null) {
        _listenToTransactions();
      } else {
        notifyListeners();
      }
    }
  }

  void _listenToTransactions() {
    if (_userId == null) return;
    
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      _transactions = snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<TransactionModel> get transactions => [..._transactions];

  double get totalBalance => totalIncome - totalExpense;

  double get totalIncome => _transactions
      .where((tx) => tx.isIncome)
      .fold(0.0, (acc, item) => acc + item.amount);

  double get totalExpense => _transactions
      .where((tx) => !tx.isIncome)
      .fold(0.0, (acc, item) => acc + item.amount);

  List<TransactionModel> get recentTransactions => _transactions.take(5).toList();

  Future<void> addTransaction(TransactionModel tx) async {
    if (_userId == null) return;
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('transactions')
        .add(tx.toMap());
  }

  Future<void> updateTransaction(String id, TransactionModel newTx) async {
    if (_userId == null) return;
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('transactions')
        .doc(id)
        .update(newTx.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    if (_userId == null) return;
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('transactions')
        .doc(id)
        .delete();
  }

  Map<String, double> get groupedExpenses {
    Map<String, double> grouped = {};
    for (var tx in _transactions.where((t) => !t.isIncome)) {
      if (grouped.containsKey(tx.category)) {
        grouped[tx.category] = grouped[tx.category]! + tx.amount;
      } else {
        grouped[tx.category] = tx.amount;
      }
    }
    return grouped;
  }
}
