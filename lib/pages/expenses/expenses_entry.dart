import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upturn_dashboard/provider/data_provider.dart';
import 'package:upturn_dashboard/widgets/expense_row.dart';

import '../../provider/expense_rows_provider.dart';

class ExpenseEntryPage extends StatefulWidget {
  const ExpenseEntryPage({super.key});

  @override
  State<ExpenseEntryPage> createState() => _ExpenseEntryPageState();
}

class _ExpenseEntryPageState extends State<ExpenseEntryPage> {
  final _formKey = GlobalKey<FormState>();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ExpenseRowsProvider()),
          ChangeNotifierProvider(create: (context) => DataProvider()),
        ],
        builder: (context, child) {
          final parentContext = context;
          int rowCount = 0;
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: context
                        .watch<ExpenseRowsProvider>()
                        .expenseRows
                        .map((e) => ExpenseRow(id: rowCount++))
                        .toList(),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ExpenseRowsProvider>().addExpenseRow();
                      },
                      child: const Text('Add Row'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.onSecondary),
                      ),
                      onPressed: uploading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  uploading = true;
                                });
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Enter Data?'),
                                        content: const Text('Is the data correct?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                uploading = false;
                                              });
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.red),
                                            child: const Text(
                                              'No',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                parentContext
                                                    .read<ExpenseRowsProvider>()
                                                    .uploadData()
                                                    .then((value) {
                                                  setState(() {
                                                    uploading = false;
                                                  });
                                                });
                                              }
                                            },
                                            child: const Text(
                                              'Yes, confirm',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              }
                            },
                      child: uploading
                          ? const CircularProgressIndicator()
                          : const Text('Submit'),
                    ),
                  ),
                ],
              ),
            
            ],
          );
        });
  }
}
