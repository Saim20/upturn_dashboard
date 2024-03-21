import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:upturn_dashboard/data/income_data.dart';
import 'package:upturn_dashboard/functions/date_time_converters.dart';

import '../../functions/responsiveness.dart';

class MonthlyIncomePage extends StatefulWidget {
  const MonthlyIncomePage({super.key});

  @override
  State<MonthlyIncomePage> createState() => _MonthlyIncomePageState();
}

class _MonthlyIncomePageState extends State<MonthlyIncomePage> {
  DateTime _month =
      DateTime(DateTime.now().year, DateTime.now().month);

  bool getData = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(
            width: isWideScreen(context) ? 200 : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Incurred Date',
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final DateTime? picked = await showMonthPicker(
                    context: context,
                    initialDate: _month,
                    firstDate: DateTime(2022),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != _month) {
                    setState(() {
                      _month = picked;
                    });
                  }
                },
                controller: TextEditingController(
                  text: formattedDate(_month).substring(3),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  getData = true;
                });
              },
              child: const Text('Get Data'),
            ),
          ),
          if (getData)
            FutureBuilder(
                future: getIncomeDataFromFirestore(_month),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Failed to fetch data');
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.$2 == false) {
                      return const Text('Failed to fetch data');
                    }
                    return DataTable(
                      border: TableBorder.all(
                        color: Colors.blueGrey,
                        width: 2,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      columns: const [
                        DataColumn(label: Text('Net Income')),
                        DataColumn(label: Text('Total Expense')),
                        DataColumn(label: Text('Total Revenue')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text(
                              'Net Income: ${snapshot.data!.$1.netIncome}')),
                          DataCell(Text(
                              'Total Expense: ${snapshot.data!.$1.totalExpense}')),
                          DataCell(Text(
                              'Total Revenue: ${snapshot.data!.$1.totalRevenue}')),
                        ]),
                      ],
                    );

                    // Column(
                    //   children: [
                    //     Text('Net Income: ${snapshot.data!.$1.netIncome}'),
                    //     Text('Total Expense: ${snapshot.data!.$1.totalExpense}'),
                    //     Text('Total Revenue: ${snapshot.data!.$1.totalRevenue}'),
                    //   ],
                    // );
                  }
                  return const Text('Failed to fetch data');
                }),
        ],
      ),
    );
  }
}

Future<(IncomeData, bool)> getIncomeDataFromFirestore(DateTime month) async {
  // get data from firestore
  // use month to filter data
  try {
    QuerySnapshot<Map<String, dynamic>> revenueData = await FirebaseFirestore
        .instance
        .collection('revenue')
        .where('transactionDate', isGreaterThanOrEqualTo: month)
        .where('transactionDate',
            isLessThanOrEqualTo: month.add(const Duration(days: 30)))
        .get();
    QuerySnapshot<Map<String, dynamic>> expenseData = await FirebaseFirestore
        .instance
        .collection('expenses')
        .where('transactionDate', isGreaterThanOrEqualTo: month)
        .where('transactionDate',
            isLessThanOrEqualTo: month.add(const Duration(days: 30)))
        .get();

    num netIncome = 0;
    num totalExpense = 0;
    num totalRevenue = 0;

    for (var e in revenueData.docs) {
      totalRevenue += e['collectibleSteadfast'] +
          e['collectiblePathao'] +
          e['collectibleSslcommerz'] -
          e['feesPathao'] -
          e['feesSteadfast'] -
          e['feesSslcommerz'] +
          e['warehouseSales'] +
          e['otherIncome'];
    }
    for (var e in expenseData.docs) {
      totalExpense += e['amount'];
    }

    netIncome = totalRevenue - totalExpense;
    return (
      IncomeData(
          netIncome: netIncome.toInt(),
          totalExpense: totalExpense.toInt(),
          totalRevenue: totalRevenue.toInt()),
      true
    );
  } catch (e) {
    log("Failed to fetch data");
    log(e.toString());
  }
  return (IncomeData(), false);
}
