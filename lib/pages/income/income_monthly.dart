import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:upturn_dashboard/data/income_data.dart';
import 'package:upturn_dashboard/functions/date_time_converters.dart';
import 'package:upturn_dashboard/provider/data_provider.dart';
import 'package:upturn_dashboard/provider/revenue_provider.dart';

import '../../functions/responsiveness.dart';

class MonthlyIncomePage extends StatefulWidget {
  const MonthlyIncomePage({super.key});

  @override
  State<MonthlyIncomePage> createState() => _MonthlyIncomePageState();
}

class _MonthlyIncomePageState extends State<MonthlyIncomePage> {
  final DateTime _monthInit =
      DateTime(DateTime.now().year, DateTime.now().month)
          .subtract(const Duration(days: 10));

  bool getData = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DateTime month = DateTime(_monthInit.year, _monthInit.month);
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: Form(
        child: ListView(
          children: [
            Column(
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
              ],
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
                      if (snapshot.data!.$2 == false) {
                        return const Text('Failed to fetch data');
                      }
                      return Column(
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
                                DataColumn(label: Text('Expense Items')),
                                DataColumn(label: Text('Amount')),
                              ],
                              rows: [
                                ...context
                                    .watch<DataProvider>()
                                    .expenseItems
                                    .map(
                                      (e) => DataRow(
                                        cells: [
                                          DataCell(Text(e)),
                                          DataCell(
                                            Text(
                                              (snapshot.data!.$1
                                                          .perItemExpense[e] ??
                                                      0)
                                                  .toString(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ],
                            ),
                          ),
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
      ),
    );
  }
}

Future<(IncomeData, bool)> getIncomeDataFromFirestore(
    DateTime startDate, BuildContext context) async {
  // get data from firestore
  // use month to filter data
  try {
    DateTime endDate = startDate.add(Duration(
        days: numberOfDaysInMonth(startDate.month, startDate.year) - 1));

    QuerySnapshot<Map<String, dynamic>> revenueData;
    QuerySnapshot<Map<String, dynamic>> expenseData;
    revenueData = await FirebaseFirestore.instance
        .collection('revenue')
        .where('transactionDate', isGreaterThanOrEqualTo: startDate)
        .where('transactionDate', isLessThanOrEqualTo: endDate)
        .get()
        .then((value) async {
      log(value.docs.length.toString());
      return value;
    });

    expenseData = await FirebaseFirestore.instance
        .collection('expenses')
        .where('transactionDate', isGreaterThanOrEqualTo: startDate)
        .where('transactionDate', isLessThanOrEqualTo: endDate)
        .get()
        .then((value) {
      log(value.docs.length.toString());
      return value;
    });

    num netIncome = 0;
    num totalExpense = 0;
    num totalRevenue = 0;
    Map<String, int> perItemExpense = {};
    Map<String, int> perTypeFee = {};

    for (var e in revenueData.docs) {
      context.read<RevenueProvider>().collectibles.forEach((key, value) {
        totalRevenue += e[key];
        if (perTypeFee.containsKey(e[key])) {
          perTypeFee[key] = perTypeFee[key]! + (e[key] as num).toInt();
        } else {
          perTypeFee[key] = (e[key] as num).toInt();
        }
      });
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
    return (
      IncomeData(
          netIncome: netIncome.toInt(),
          totalExpense: totalExpense.toInt(),
          totalRevenue: totalRevenue.toInt(),
          perItemExpense: perItemExpense),
      true
    );
  } catch (e) {
    log("Failed to fetch data");
    log(e.toString());
  }
  return (IncomeData(), false);
}
