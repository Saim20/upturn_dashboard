import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upturn_dashboard/functions/responsiveness.dart';
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ExpenseRowsProvider()),
          ChangeNotifierProvider(create: (context) => DataProvider()),
        ],
        builder: (context, child) {
          int rowCount = 0;
          return Column(
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ExpenseRowsProvider>().uploadData();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          );
        });
  }

  Widget bodyContents(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, context) {
    Widget list = Expanded(
      child: ListView(
        children: snapshot.data!
            .map((e) => Card(
                  child: ListTile(
                    title: Text(e['name']),
                    subtitle: Text(e['email']),
                  ),
                ))
            .toList(),
      ),
    );

    if (isWideScreen(context)) {
      return Expanded(
        child: Row(
          children: [
            list,
            SizedBox(
              width: getPercentageOfScreenWidth(context, 0.4),
            )
          ],
        ),
      );
    } else {
      return list;
    }
  }
}
