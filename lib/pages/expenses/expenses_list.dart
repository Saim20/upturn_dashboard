import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upturn_dashboard/functions/date_time_converters.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  DateTime startDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime endDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  bool getData = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Filter(
              initialDate: startDate,
              label: 'Start Date',
              onChanged: (DateTime selectedDate) {
                startDate = selectedDate;
              },
            ),
            Filter(
              initialDate: endDate,
              label: 'End Date',
              onChanged: (DateTime selectedDate) {
                endDate = selectedDate;
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
                .collection('expenses')
                .where('date', isGreaterThanOrEqualTo: startDate)
                .where('date', isLessThanOrEqualTo: endDate)
                .get(), // Function to fetch data from Firebase
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                num totalAmount = 0;
                for (var i = 0; i < snapshot.data!.docs.length; i++) {
                  totalAmount += snapshot.data!.docs[i]['cashAmount'];
                }

                return Expanded(
                  child: SingleChildScrollView(
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
                        // headingRowColor:
                        //     MaterialStateProperty.all(Colors.blueGrey),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text('Date'),
                          ),
                          DataColumn(
                            label: Text('Expense Item'),
                          ),
                          DataColumn(
                            label: Text('Payment Method'),
                          ),
                          DataColumn(
                            label: Text('Amount'),
                          ),
                        ],
                        rows: [
                          ...snapshot.data!.docs.map<DataRow>(
                            (DocumentSnapshot document) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Text(
                                      formattedDate(
                                          (document['date'] as Timestamp)
                                              .toDate()),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      document['expenseItem'],
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      document['paymentMethod'],
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      document['cashAmount'].toString(),
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
                                  'Total:',
                                ),
                              ),
                              DataCell(
                                Text(
                                  totalAmount.toString(),
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
            },
          ),
      ],
    );
  }
}

class Filter extends StatefulWidget {
  const Filter({
    super.key,
    required this.onChanged,
    required this.initialDate,
    required this.label,
  });

  final Function(DateTime picked) onChanged;
  final DateTime initialDate;
  final String label;

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  var _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
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
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
            );
            if (picked != null && picked != _selectedDate) {
              setState(() {
                _selectedDate = picked;
                widget.onChanged(_selectedDate);
              });
            }
          },
          controller: TextEditingController(
            text: _selectedDate == null ? '' : formattedDate(_selectedDate),
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
