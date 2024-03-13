import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExpensesMainPage extends StatelessWidget {
  const ExpensesMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //heading for navigation
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Expenses options',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.input_outlined),
            label: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('Entry'),
            ),
            onPressed: () {
              context.go('/expenses/entry');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.table_chart_outlined),
            label: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('List'),
            ),
            onPressed: () {
              context.go('/expenses/list');
            },
          ),
        ),
      ],
    );
  }
}
