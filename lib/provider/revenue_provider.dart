import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upturn_dashboard/data/revenue_data.dart';

class RevenueProvider with ChangeNotifier {
  final List<RevenueData> _revenueDatas = [];

  static final Map<String, int> _collectibles = {};
  static final Map<String, int> _fees = {};

  static Map<String, int> get collectibles => _collectibles;
  static Map<String, int> get fees => _fees;

  List<RevenueData> get revenueDatas => _revenueDatas;

  RevenueData expenseRow(int n) => _revenueDatas[n];

  RevenueProvider() {
    FirebaseFirestore.instance
        .collection('data')
        .doc('options')
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data()!;

      data['collectibles']
          .toString()
          .substring(1, data['collectibles'].toString().length - 1)
          .split(',')
          .forEach((element) {
        _collectibles[element] = 0;
      });

      data['fees']
          .toString()
          .substring(1, data['fees'].toString().length - 1)
          .split(',')
          .forEach((element) {
        _fees[element] = 0;
      });
    });
  }

  void addRevenueRow(DateTime transactionDate) {
    _revenueDatas.add(RevenueData(
        transactionDate: transactionDate,
        collectibles: Map<String, int>.from(_collectibles),
        fees: Map<String, int>.from(_fees)));
    notifyListeners();
  }

  void removeRevenueRow(int id) {
    _revenueDatas.removeAt(id);
    notifyListeners();
  }

  Future<bool> uploadData() async {
    for (var e in revenueDatas) {
      Map<String, int> collectibles = {};
      Map<String, int> fees = {};
      e.collectibles.forEach((key, value) {
        collectibles[key] = value;
      });
      e.fees.forEach((key, value) {
        fees[key] = value;
      });
      await FirebaseFirestore.instance.collection('revenue').add({
        'transactionDate': e.transactionDate,
        ...collectibles,
        ...fees,
        // 'collectibleSteadfast': e.collectibleSteadfast,
        // 'collectiblePathao': e.collectiblePathao,
        // 'collectibleSslcommerz': e.collectibleSslcommerz,
        // 'feesPathao': e.feesPathao,
        // 'feesSteadfast': e.feesSteadfast,
        // 'feesSslcommerz': e.feesSslcommerz,
        // 'warehouseSales': e.warehouseSales,
        // 'otherIncome': e.otherIncome,
      });
    }
    _revenueDatas.clear();
    notifyListeners();
    return true;
  }
}
