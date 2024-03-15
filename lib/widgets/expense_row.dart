import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:upturn_dashboard/functions/responsiveness.dart';
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
  DateTime? _transactionDate;
  DateTime? _incurredDate;
  String? _expenseItem;
  String? _paymentMethod;

  final cashController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _transactionDate = context
        .watch<ExpenseRowsProvider>()
        .expenseRows[widget.id]
        .transactionDate;
    _incurredDate = context
        .watch<ExpenseRowsProvider>()
        .expenseRows[widget.id]
        .incurredDate;
    _expenseItem =
        context.watch<ExpenseRowsProvider>().expenseRows[widget.id].expenseItem;
    _paymentMethod = context
        .watch<ExpenseRowsProvider>()
        .expenseRows[widget.id]
        .paymentMethod;

    cashController.text = context
        .watch<ExpenseRowsProvider>()
        .expenseRows[widget.id]
        .amount
        .toString();

    List<Widget> contents = [
      SizedBox(
        width: isWideScreen(context) ? 200 : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Transaction Date',
            ),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _transactionDate ?? DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != _transactionDate) {
                setState(() {
                  if (_incurredDate!.isAfter(picked)) {
                    _incurredDate = DateTime(
                        picked.year, picked.month);
                    context
                        .read<ExpenseRowsProvider>()
                        .expenseRows[widget.id]
                        .incurredDate = _incurredDate!;
                  }
                  context
                      .read<ExpenseRowsProvider>()
                      .expenseRows[widget.id]
                      .transactionDate = picked;
                });
              }
            },
            controller: TextEditingController(
              text: _transactionDate == null
                  ? ''
                  : formattedDate(_transactionDate!),
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
                initialDate: _incurredDate ?? DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: _transactionDate,
              );
              if (picked != null && picked != _incurredDate) {
                setState(() {
                  context
                      .read<ExpenseRowsProvider>()
                      .expenseRows[widget.id]
                      .incurredDate = picked;
                });
              }
            },
            controller: TextEditingController(
              text: _incurredDate == null
                  ? ''
                  : formattedDate(_incurredDate!).substring(3),
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
      SizedBox(
        width: isWideScreen(context) ? 320 : null,
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
        width: isWideScreen(context) ? 240 : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Payment Method',
            ),
            items:
                context.watch<DataProvider>().paymentMethods.map((String item) {
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
        width: isWideScreen(context) ? 240 : null,
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
                  .amount = int.parse(newValue!);
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
    ];

    return isWideScreen(context)
        ? Row(
            children: contents,
          )
        : Column(
            children: contents,
          );
  }
}
