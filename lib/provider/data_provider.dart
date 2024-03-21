import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  final int s = 10;

  get sett => s;

  List<String> _paymentMethods = [];
  List<String> _expenseItems = [];


  List<String> get paymentMethods => _paymentMethods;
  List<String> get expenseItems => _expenseItems;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? dataStream;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? dataSubscription;

  DataProvider() {
    initialize();
  }

  Future<void> initialize() async {
    dataStream ??= FirebaseFirestore.instance
        .collection('data')
        .doc('options')
        .snapshots();
    dataSubscription ??= dataStream!.listen((event) {
      Map<String, dynamic> data = event.data()!;

      _paymentMethods = data['paymentMethods']
          .toString()
          .substring(1, data['paymentMethods'].toString().length - 1)
          .split(',')
          .map((e) => e)
          .toList();

      _expenseItems = data['expenseItems']
          .toString()
          .substring(1, data['expenseItems'].toString().length - 1)
          .split(',')
          .map((e) => e)
          .toList();
          
      notifyListeners();
    });
  }
}
