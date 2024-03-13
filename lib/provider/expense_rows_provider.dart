import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upturn_dashboard/data/expense_row_data.dart';

class ExpenseRowsProvider extends ChangeNotifier {
  final List<ExpenseRowData> _expenseRows = [
    ExpenseRowData(),
  ];

  List<ExpenseRowData> get expenseRows => _expenseRows;

  ExpenseRowData expenseRow(int n) => _expenseRows[n];

  void addExpenseRow() {
    _expenseRows.add(ExpenseRowData());
    notifyListeners();
  }

  void removeExpenseRow(int id) {
    _expenseRows.removeAt(id);
    notifyListeners();
  }

  void uploadData() async {
    try {
      for (var e in expenseRows) {
        // log(e.selectedDate.toString());
        // log(e.cashAmount.toString());
        // log(e.expenseItem.toString());
        // log(e.paymentMethod.toString());

        await FirebaseFirestore.instance.collection('expenses').add({
          'cashAmount': e.cashAmount,
          'date': e.selectedDate,
          'expenseItem': e.expenseItem,
          'paymentMethod': e.paymentMethod,
        }).then((value) => _expenseRows.remove(e));
      }
      notifyListeners();
    } catch (e) {
      log(e.toString());
      return;
    }
  }
}
