
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upturn_dashboard/data/expense_data.dart';

class ExpenseRowsProvider with ChangeNotifier {
  final List<ExpenseData> _expenseRows = [
    ExpenseData(),
  ];

  List<ExpenseData> get expenseRows => _expenseRows;

  ExpenseData expenseRow(int n) => _expenseRows[n];

  void addExpenseRow() {
    _expenseRows.add(ExpenseData());
    notifyListeners();
  }

  void removeExpenseRow(int id) {
    _expenseRows.removeAt(id);
    notifyListeners();
  }

  Future<bool> uploadData() async {
    for (var e in expenseRows) {
      // log(e.selectedDate.toString());
      // log(e.cashAmount.toString());
      // log(e.expenseItem.toString());
      // log(e.paymentMethod.toString());

      await FirebaseFirestore.instance
          .collection('expenses')
          .add({
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
