import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:upturn_dashboard/provider/data_provider.dart';
import 'package:upturn_dashboard/provider/expense_rows_provider.dart';

import '../functions/date_time_converters.dart';

class ExpenseRow extends StatefulWidget {
  const ExpenseRow({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<ExpenseRow> createState() => _ExpenseRowState();
}

class _ExpenseRowState extends State<ExpenseRow> {
  DateTime? _selectedDate;
  String? _expenseItem;
  String? _paymentMethod;

  final cashController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _selectedDate = context
        .watch<ExpenseRowsProvider>()
        .expenseRows[widget.id]
        .selectedDate;
    _expenseItem =
        context.watch<ExpenseRowsProvider>().expenseRows[widget.id].expenseItem;
    _paymentMethod = context
        .watch<ExpenseRowsProvider>()
        .expenseRows[widget.id]
        .paymentMethod;

    cashController.text = context
        .watch<ExpenseRowsProvider>()
        .expenseRows[widget.id]
        .cashAmount
        .toString();

    return Row(
      children: [
        SizedBox(
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
                    context
                        .read<ExpenseRowsProvider>()
                        .expenseRows[widget.id]
                        .selectedDate = picked;
                  });
                }
              },
              controller: TextEditingController(
                text: _selectedDate == null
                    ? ''
                    : formattedDate(_selectedDate!),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                return null;
              },
            ),
          ),
        ),
        
        SizedBox(
          width: 320,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Expense Item',
              ),
              items:
                  context.watch<DataProvider>().expenseItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  context
                      .read<ExpenseRowsProvider>()
                      .expenseRows[widget.id]
                      .expenseItem = newValue;
                  log(context
                      .read<ExpenseRowsProvider>()
                      .expenseRows[widget.id]
                      .expenseItem
                      .toString());
                });
              },
              value: _expenseItem,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an expense item';
                }
                return null;
              },
            ),
          ),
        ),
        SizedBox(
          width: 240,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Payment Method',
              ),
              items: context
                  .watch<DataProvider>()
                  .paymentMethods
                  .map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  context
                      .read<ExpenseRowsProvider>()
                      .expenseRows[widget.id]
                      .paymentMethod = newValue;
                  log(context
                      .read<ExpenseRowsProvider>()
                      .expenseRows[widget.id]
                      .paymentMethod
                      .toString());
                });
              },
              value: _paymentMethod,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a payment method';
                }
                return null;
              },
            ),
          ),
        ),
        SizedBox(
          width: 240,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Cash Amount',
              ),
              controller: cashController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a cash amount';
                }
                return null;
              },
              onChanged: (String? newValue) {
                context
                    .read<ExpenseRowsProvider>()
                    .expenseRows[widget.id]
                    .cashAmount = int.parse(newValue!);
                log(context
                    .read<ExpenseRowsProvider>()
                    .expenseRows[widget.id]
                    .cashAmount
                    .toString());
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              context.read<ExpenseRowsProvider>().removeExpenseRow(widget.id);
            },
            child: const Icon(Icons.remove_circle_outline),
          ),
        ),
      ],
    );
  }
}
