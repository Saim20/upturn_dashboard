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
                  onPressed: uploading
                      ? null
                      : () async {
                          setState(() {
                            uploading = true;
                          });
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Uploading Data'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          uploading = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        if (_formKey.currentState!.validate()) {
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
                                      child: const Text('Confirm'),
                                    )
                                  ],
                                );
                              });
                        },
                  child: uploading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Submit'),
                ),
              ),
            ],
          );
        });
  }
}
