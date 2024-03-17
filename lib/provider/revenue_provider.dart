import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upturn_dashboard/data/revenue_data.dart';

class RevenueProvider with ChangeNotifier {
  final List<RevenueData> _revenueRows = [
    RevenueData(),
  ];

  List<RevenueData> get revenueRows => _revenueRows;

  RevenueData expenseRow(int n) => _revenueRows[n];

  void addRevenueRow() {
    _revenueRows.add(RevenueData());
    notifyListeners();
  }

  void removeRevenueRow(int id) {
    _revenueRows.removeAt(id);
    notifyListeners();
  }

  Future<bool> uploadData() async {
    for (var e in revenueRows) {
      await FirebaseFirestore.instance.collection('revenue').add({
        'transactionDate': e.transactionDate,
        'collectibleSteadfast': e.collectibleSteadfast,
        'collectiblePathao': e.collectiblePathao,
        'collectibleSslcommerz': e.collectibleSslcommerz,
        'feesPathao': e.feesPathao,
        'feesSteadfast': e.feesSteadfast,
        'feesSslcommerz': e.feesSslcommerz,
        'warehouseSales': e.warehouseSales,
        'otherIncome': e.otherIncome,
      });
    }
    _revenueRows.clear();
    notifyListeners();
    return true;
  }
}
