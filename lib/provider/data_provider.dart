import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  final int s = 10;

  get sett => s;

  static List<String> _paymentMethods = [];
  static List<String> _expenseItems = [];

  static List<String> _collectibles = [];
  static List<String> _fees = [];

  static List<String> get collectibles => _collectibles;
  static List<String> get fees => _fees;

  static List<String> get paymentMethods => _paymentMethods;
  static List<String> get expenseItems => _expenseItems;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? dataStream;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? dataSubscription;

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
          .map((e) => e.trim())
          .toList();

      _expenseItems = data['expenseItems']
          .toString()
          .substring(1, data['expenseItems'].toString().length - 1)
          .split(',')
          .map((e) => e.trim())
          .toList();

      _collectibles = data['collectibles']
          .toString()
          .substring(1, data['collectibles'].toString().length - 1)
          .split(',')
          .map((e) => e.trim())
          .toList();

      _fees = data['fees']
          .toString()
          .substring(1, data['fees'].toString().length - 1)
          .split(',')
          .map((e) => e.trim())
          .toList();

      notifyListeners();
    });
  }
}
