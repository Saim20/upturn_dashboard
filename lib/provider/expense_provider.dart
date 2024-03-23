import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upturn_dashboard/data/expense_data.dart';

class ExpensesProvider with ChangeNotifier {
  final List<ExpenseData> _expenseRows = [];

  List<ExpenseData> get expenseRows => _expenseRows;

  ExpenseData expenseRow(int n) => _expenseRows[n];

  void addExpenseRow(DateTime selectedTransactionDate, String paymentMethod) {
    _expenseRows.add(
      ExpenseData(
        transactionDate: selectedTransactionDate,
        incurredDate: DateTime(
            selectedTransactionDate.year, selectedTransactionDate.month),
        paymentMethod: paymentMethod,
      ),
    );
    notifyListeners();
  }

  void removeExpenseRow(int id) {
    _expenseRows.removeAt(id);
    notifyListeners();
  }

  Future<bool> uploadData() async {
    for (var e in expenseRows) {
      await FirebaseFirestore.instance.collection('expenses').add({
        'amount': e.amount,
        'expenseItem': e.expenseItem,
        'paymentMethod': e.paymentMethod,
        'incurredDate': e.incurredDate,
        'transactionDate': e.transactionDate,
      });
    }
    _expenseRows.clear();
    notifyListeners();
    return true;
  }
}
