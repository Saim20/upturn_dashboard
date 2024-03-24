import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upturn_dashboard/data/revenue_data.dart';
import 'package:upturn_dashboard/provider/data_provider.dart';

class RevenueProvider with ChangeNotifier {
  final List<RevenueData> _revenueDatas = [];



  List<RevenueData> get revenueDatas => _revenueDatas;
  

  RevenueData expenseRow(int n) => _revenueDatas[n];

  void addRevenueRow(DateTime transactionDate) {
    Map<String, int?> collectiblesMap = {};
    Map<String, int?> feesMap = {};
    for (var element in DataProvider.collectibles) {
      collectiblesMap[element] = null;
    }
    for (var element in DataProvider.fees) {
      feesMap[element] = null;
    }
    _revenueDatas.add(
      RevenueData(
        transactionDate: transactionDate,
        collectibles: collectiblesMap,
        fees: feesMap,
      ),
    );
    notifyListeners();
  }

  void removeRevenueRow(int id) {
    _revenueDatas.removeAt(id);
    notifyListeners();
  }

  Future<bool> uploadData() async {
    for (var e in revenueDatas) {
      Map<String, int?> collectibles = {};
      Map<String, int?> fees = {};
      e.collectibles.forEach((key, value) {
        collectibles[key] = value ?? 0;
      });
      e.fees.forEach((key, value) {
        fees[key] = value ?? 0;
      });

      await FirebaseFirestore.instance.collection('revenue').add({
        'transactionDate': e.transactionDate,
        ...collectibles,
        ...fees,
        'Fees SslCommerz':
            (collectibles['Collectible SslCommerz']! * 0.025).ceil().toInt(),
        // 'collectibleSteadfast': e.collectibleSteadfast,
        // 'collectiblePathao': e.collectiblePathao,
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
