
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upturn_dashboard/functions/date_time_converters.dart';

class ExpenseTablePage extends StatefulWidget {
  const ExpenseTablePage({super.key});

  @override
  State<ExpenseTablePage> createState() => _ExpenseTablePageState();
}

class _ExpenseTablePageState extends State<ExpenseTablePage> {
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  bool getData = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Filter(
          initialDate: selectedDate,
          onChanged: (DateTime selectedDate) {
            this.selectedDate = selectedDate;
          },
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              getData = true;
            });
          },
          child: const Text('Get Data'),
        ),
        if(getData)
        FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('expenses')
              .where('date', isGreaterThanOrEqualTo: selectedDate)
              .get(), // Function to fetch data from Firebase
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return DataTable(
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
                  rows: snapshot.data!.docs
                      .map<DataRow>((DocumentSnapshot document) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            formattedDate((document['date'] as Timestamp).toDate()),
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
                  }).toList());
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
  });

  final Function(DateTime picked) onChanged;
  final DateTime initialDate;

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
          decoration: const InputDecoration(
            labelText: 'Date',
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
            text: _selectedDate == null
                ? ''
                : formattedDate(_selectedDate),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a date';
            }
            return null;
          },
        ),
      ),
    );
  }
}
