import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upturn_dashboard/functions/date_time_converters.dart';
import 'package:upturn_dashboard/provider/data_provider.dart';

class RevenueListPage extends StatefulWidget {
  const RevenueListPage({super.key});

  @override
  State<RevenueListPage> createState() => _RevenueListPageState();
}

class _RevenueListPageState extends State<RevenueListPage> {
  DateTime startDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime endDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  bool getData = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Filter(
                startDate: startDate,
                label: 'Start Date',
                onChanged: (DateTime selectedDate) {
                  startDate = selectedDate;
                  if (startDate.isAfter(endDate)) {
                    setState(() {
                      endDate = startDate;
                    });
                  }
                },
              ),
              Filter(
                startDate: endDate,
                label: 'End Date',
                onChanged: (DateTime selectedDate) {
                  endDate = selectedDate;
                  if (endDate.isBefore(startDate)) {
                    setState(() {
                      startDate = endDate;
                    });
                  }
                },
              ),
            ],
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
              future: FirebaseFirestore.instance
                  .collection('revenue')
                  .where('transactionDate', isGreaterThanOrEqualTo: startDate)
                  .where('transactionDate', isLessThanOrEqualTo: endDate)
                  .get(), // Function to fetch data from Firebase
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  num totalRevenue = 0;
                  for (var i = 0; i < snapshot.data!.docs.length; i++) {
                    for (var key in DataProvider.collectibles) {
                      totalRevenue += snapshot.data!.docs[i][key];
                    }
                  }
                  num totalFees = 0;
                  for (var i = 0; i < snapshot.data!.docs.length; i++) {
                    for (var key in DataProvider.fees) {
                      totalFees += snapshot.data!.docs[i][key];
                    }
                  }

                  List<DataColumn> collectibles = [];

                  for (var key in DataProvider.collectibles) {
                    collectibles.add(
                      DataColumn(
                        label: Text(key),
                      ),
                    );
                  }

                  List<DataColumn> fees = [];
                  for (var key in DataProvider.fees) {
                    fees.add(
                      DataColumn(
                        label: Text(key),
                      ),
                    );
                  }

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
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
                            columns: [
                              const DataColumn(
                                label: Text('Transaction Date'),
                              ),
                              const DataColumn(
                                label: Text('Fees SslCommerz'),
                              ),
                              ...DataProvider.collectibles
                                  .map<DataColumn>(
                                (String key) => DataColumn(
                                  label: Text(key),
                                ),
                              ),
                              ...DataProvider.fees.map<DataColumn>(
                                (String key) => DataColumn(
                                  label: Text(key),
                                ),
                              ),
                            ],
                            rows: [
                              ...snapshot.data!.docs.map<DataRow>(
                                (DocumentSnapshot document) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          formattedDate(
                                            (document['transactionDate']
                                                    as Timestamp)
                                                .toDate(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          document['Fees SslCommerz'].toString(),
                                        ),
                                      ),
                                      ...DataProvider.collectibles
                                          .map<DataCell>(
                                        (String key) => DataCell(
                                          Text(
                                            document[key].toString(),
                                          ),
                                        ),
                                      ),
                                      ...DataProvider.fees
                                          .map<DataCell>(
                                        (String key) => DataCell(
                                          Text(
                                            document[key].toString(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              DataRow(
                                cells: [
                                  const DataCell(
                                    Text(
                                      '',
                                    ),
                                  ),
                                  const DataCell(
                                    Text(
                                      '',
                                    ),
                                  ),
                                  const DataCell(
                                    Text(
                                      '',
                                    ),
                                  ),
                                  const DataCell(
                                    Text(
                                      'Total Revenue',
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      totalRevenue.toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    Text(
                                      'Total Fees:',
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      totalFees.toString(),
                                    ),
                                  ),
                                  const DataCell(
                                    Text(
                                      'Net:',
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      (totalRevenue - totalFees).toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}

class Filter extends StatefulWidget {
  const Filter({
    super.key,
    required this.onChanged,
    required this.startDate,
    required this.label,
  });

  final Function(DateTime picked) onChanged;
  final DateTime startDate;
  final String label;

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  late DateTime _transactionDate;

  @override
  void initState() {
    super.initState();
    _transactionDate = widget.startDate;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: widget.label,
          ),
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _transactionDate,
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
            );
            if (picked != null && picked != _transactionDate) {
              setState(() {
                _transactionDate = picked;
                widget.onChanged(_transactionDate);
              });
            }
          },
          controller: TextEditingController(
            text: formattedDate(_transactionDate),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
        ),
      ),
    );
  }
}
