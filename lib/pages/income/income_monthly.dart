import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:upturn_dashboard/data/income_data.dart';
import 'package:upturn_dashboard/functions/date_time_converters.dart';
import 'package:upturn_dashboard/provider/data_provider.dart';

import '../../functions/responsiveness.dart';

class MonthlyIncomePage extends StatefulWidget {
  const MonthlyIncomePage({super.key});

  @override
  State<MonthlyIncomePage> createState() => _MonthlyIncomePageState();
}

class _MonthlyIncomePageState extends State<MonthlyIncomePage> {
  DateTime month = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month)
          .subtract(Duration(
              days: numberOfDaysInMonth(
                  DateTime.now().year, DateTime.now().month)))
          .year,
      DateTime(DateTime.now().year, DateTime.now().month)
          .subtract(Duration(
              days: numberOfDaysInMonth(
                  DateTime.now().year, DateTime.now().month)))
          .month);

  bool getData = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: Form(
        child: Column(
          children: [
            SizedBox(
              width: isWideScreen(context) ? 200 : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Income For',
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final DateTime? picked = await showMonthPicker(
                      context: context,
                      initialDate: month,
                      firstDate: DateTime(2022),
                      lastDate: DateTime.now().subtract(
                        DateTime.now().day >= 30
                            ? const Duration(days: 32)
                            : const Duration(days: 30),
                      ),
                    );
                    if (picked != null && picked != month) {
                      setState(() {
                        month = picked;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: formattedDate(month).substring(3),
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
                future: getIncomeDataFromFirestore(month, context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Column(
                      children: [
                        CircularProgressIndicator(),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text('Failed to fetch data');
                  }
                  if (snapshot.hasData) {
                    getData = false;

                    List<DataRow> collectibleRows = [];
                    List<DataRow> feeRows = [];

                    for (var key in DataProvider.collectibles) {
                      collectibleRows.add(
                        DataRow(
                          cells: [
                            DataCell(Text(key)),
                            DataCell(Text(
                                (snapshot.data!.perTypeCollectible[key] ?? 0)
                                    .toString())),
                          ],
                        ),
                      );
                    }

                    for (var key in DataProvider.fees) {
                      feeRows.add(
                        DataRow(
                          cells: [
                            DataCell(Text(key)),
                            DataCell(Text((snapshot.data!.perTypeFee[key] ?? 0)
                                .toString())),
                          ],
                        ),
                      );
                    }
                    feeRows.add(
                      DataRow(
                        cells: [
                          const DataCell(Text('Fees SslCommerz')),
                          DataCell(Text(
                              (snapshot.data!.perTypeFee['Fees SslCommerz'] ??
                                      0)
                                  .toString())),
                        ],
                      ),
                    );

                    return Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DataTable(
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
                                    DataColumn(label: Text('Total Revenue')),
                                    DataColumn(label: Text('Total Expense')),
                                    DataColumn(label: Text('Net Income')),
                                  ],
                                  rows: [
                                    DataRow(cells: [
                                      DataCell(Text(
                                          'Total Revenue: ${snapshot.data!.totalRevenue}')),
                                      DataCell(Text(
                                          'Total Expense: ${snapshot.data!.totalExpense}')),
                                      DataCell(Text(
                                          'Net Income: ${snapshot.data!.netIncome}')),
                                    ]),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DataTable(
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
                                        DataColumn(
                                            label: Text('Expense Items')),
                                        DataColumn(
                                            label: Text('Expense Amount')),
                                      ],
                                      rows: [
                                        ...DataProvider.expenseItems.map(
                                          (e) => DataRow(
                                            cells: [
                                              DataCell(Text(e)),
                                              DataCell(
                                                Text(
                                                  (snapshot.data!.perItemExpense[
                                                              e] ??
                                                          0)
                                                      .toString(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataRow(cells: [
                                          const DataCell(Text('Total:')),
                                          DataCell(
                                            Text(
                                              snapshot
                                                  .data!.perItemExpense.values
                                                  .fold(
                                                      0,
                                                      (previousValue,
                                                              element) =>
                                                          previousValue +
                                                          element)
                                                  .toString(),
                                            ),
                                          ),
                                        ])
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DataTable(
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
                                        DataColumn(
                                            label: Text('Collectible Type')),
                                        DataColumn(
                                            label: Text('Collectible Amount')),
                                      ],
                                      rows: [
                                        ...collectibleRows,
                                        DataRow(cells: [
                                          const DataCell(Text('Total:')),
                                          DataCell(
                                            Text(
                                              snapshot.data!.perTypeCollectible
                                                  .values
                                                  .fold(
                                                      0,
                                                      (previousValue,
                                                              element) =>
                                                          previousValue +
                                                          element)
                                                  .toString(),
                                            ),
                                          ),
                                        ])
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DataTable(
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
                                        DataColumn(label: Text('Fee Type')),
                                        DataColumn(label: Text('Fee Amount')),
                                      ],
                                      rows: [
                                        ...feeRows,
                                        DataRow(cells: [
                                          const DataCell(Text('Total:')),
                                          DataCell(
                                            Text(
                                              snapshot.data!.perTypeFee.values
                                                  .fold(
                                                      0,
                                                      (previousValue,
                                                              element) =>
                                                          previousValue +
                                                          element)
                                                  .toString(),
                                            ),
                                          ),
                                        ])
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const Text('Failed to fetch data');
                },
              ),
          ],
        ),
      ),
    );
  }
}

Future<IncomeData?> getIncomeDataFromFirestore(
    DateTime startDate, BuildContext context) async {
  DateTime endDate = startDate.add(
      Duration(days: numberOfDaysInMonth(startDate.month, startDate.year) - 1));

  QuerySnapshot<Map<String, dynamic>> revenueData;
  QuerySnapshot<Map<String, dynamic>> expenseData;
  try {
    revenueData = await FirebaseFirestore.instance
        .collection('revenue')
        .where('transactionDate', isGreaterThanOrEqualTo: startDate)
        .where('transactionDate', isLessThanOrEqualTo: endDate)
        .get();

    expenseData = await FirebaseFirestore.instance
        .collection('expenses')
        .where('transactionDate', isGreaterThanOrEqualTo: startDate)
        .where('transactionDate', isLessThanOrEqualTo: endDate)
        .get();
  } catch (e) {
    log("Failed to fetch data");
    log(e.toString());
    return null;
  }
  num netIncome = 0;
  num totalExpense = 0;
  num totalRevenue = 0;
  Map<String, int> perItemExpense = {};
  Map<String, int> perTypeCollectible = {};
  Map<String, int> perTypeFee = {};

  for (var e in revenueData.docs) {
    // ignore: use_build_context_synchronously
    for (var collectible in DataProvider.collectibles) {
      totalRevenue += e[collectible];
      if (perTypeCollectible.containsKey(collectible)) {
        perTypeCollectible[collectible] =
            perTypeCollectible[collectible]! + (e[collectible] as num).toInt();
      } else {
        perTypeCollectible[collectible] = (e[collectible] as num).toInt();
      }
    }
    // ignore: use_build_context_synchronously
    for (var fee in DataProvider.fees) {
      totalExpense += e[fee];
      if (perTypeFee.containsKey(fee)) {
        perTypeFee[fee] = perTypeFee[fee]! + (e[fee] as num).toInt();
      } else {
        perTypeFee[fee] = (e[fee] as num).toInt();
      }
    }
    if (perTypeFee.containsKey(e['Fees SslCommerz'])) {
      perTypeFee['Fees SslCommerz'] = perTypeFee['Fees SslCommerz']! +
          (e['Fees SslCommerz'] as num).toInt();
    } else {
      perTypeFee['Fees SslCommerz'] = (e['Fees SslCommerz'] as num).toInt();
    }
  }
  for (var e in expenseData.docs) {
    totalExpense += e['amount'];
    if (perItemExpense.containsKey(e['expenseItem'])) {
      perItemExpense[e['expenseItem']] =
          perItemExpense[e['expenseItem']]! + (e['amount'] as num).toInt();
    } else {
      perItemExpense[e['expenseItem']] = (e['amount'] as num).toInt();
    }
  }

  netIncome = totalRevenue - totalExpense;
  return IncomeData(
    netIncome: netIncome.toInt(),
    totalExpense: totalExpense.toInt(),
    totalRevenue: totalRevenue.toInt(),
    perItemExpense: perItemExpense,
    perTypeCollectible: perTypeCollectible,
    perTypeFee: perTypeFee,
  );
}
