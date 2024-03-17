import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:upturn_dashboard/functions/responsiveness.dart';
import 'package:upturn_dashboard/provider/revenue_provider.dart';

import '../functions/date_time_converters.dart';

class RevenueRow extends StatefulWidget {
  const RevenueRow({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<RevenueRow> createState() => _RevenueRowState();
}

class _RevenueRowState extends State<RevenueRow> {
  DateTime? _transactionDate;

  final collectiblePathaoController = TextEditingController();
  final collectibleSteadfastController = TextEditingController();
  final collectibleSslcommerzController = TextEditingController();
  final feesPathaoController = TextEditingController();
  final feesSteadfastController = TextEditingController();
  final feesSslcommerzController = TextEditingController();
  final warehouseSalesController = TextEditingController();
  final otherIncomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _transactionDate =
        context.watch<RevenueProvider>().revenueRows[widget.id].transactionDate;

    collectiblePathaoController.text = context
        .watch<RevenueProvider>()
        .revenueRows[widget.id]
        .collectiblePathao
        .toString();
    collectibleSteadfastController.text = context
        .watch<RevenueProvider>()
        .revenueRows[widget.id]
        .collectibleSteadfast
        .toString();
    collectibleSslcommerzController.text = context
        .watch<RevenueProvider>()
        .revenueRows[widget.id]
        .collectibleSslcommerz
        .toString();
    feesPathaoController.text = context
        .watch<RevenueProvider>()
        .revenueRows[widget.id]
        .feesPathao
        .toString();
    feesSteadfastController.text = context
        .watch<RevenueProvider>()
        .revenueRows[widget.id]
        .feesSteadfast
        .toString();
    feesSslcommerzController.text = context
        .watch<RevenueProvider>()
        .revenueRows[widget.id]
        .feesSslcommerz
        .toString();
    warehouseSalesController.text = context
        .watch<RevenueProvider>()
        .revenueRows[widget.id]
        .warehouseSales
        .toString();
    otherIncomeController.text = context
        .watch<RevenueProvider>()
        .revenueRows[widget.id]
        .otherIncome
        .toString();

    double textFieldWidth = (MediaQuery.of(context).size.width - 350) / 8;


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
                  context
                      .read<RevenueProvider>()
                      .revenueRows[widget.id]
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
        width: isWideScreen(context) ? textFieldWidth : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Collectible Steadfast',
            ),
            controller: collectibleSteadfastController,
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
              context.read<RevenueProvider>().revenueRows[widget.id].collectibleSteadfast =
                  int.parse(newValue!);
            },
          ),
        ),
      ),
      SizedBox(
        width: isWideScreen(context) ? textFieldWidth : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Fees Steadfast',
            ),
            controller: feesSteadfastController,
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
              context.read<RevenueProvider>().revenueRows[widget.id].feesSteadfast =
                  int.parse(newValue!);
            },
          ),
        ),
      ),
      SizedBox(
        width: isWideScreen(context) ? textFieldWidth : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Collectible Pathao',
            ),
            controller: collectiblePathaoController,
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
              context.read<RevenueProvider>().revenueRows[widget.id].collectiblePathao =
                  int.parse(newValue!);
            },
          ),
        ),
      ),
      SizedBox(
        width: isWideScreen(context) ? textFieldWidth : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Fees Pathao',
            ),
            controller: feesPathaoController,
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
              context.read<RevenueProvider>().revenueRows[widget.id].feesPathao =
                  int.parse(newValue!);
            },
          ),
        ),
      ),
      SizedBox(
        width: isWideScreen(context) ? textFieldWidth : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Collectible SSLCommerz',
            ),
            controller: collectibleSslcommerzController,
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
              context.read<RevenueProvider>().revenueRows[widget.id].collectibleSslcommerz =
                  int.parse(newValue!);
            },
          ),
        ),
      ),
      SizedBox(
        width: isWideScreen(context) ? textFieldWidth : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Fees SSLCommerz',
            ),
            controller: feesSslcommerzController,
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
              context.read<RevenueProvider>().revenueRows[widget.id].feesSslcommerz =
                  int.parse(newValue!);
            },
          ),
        ),
      ),
      SizedBox(
        width: isWideScreen(context) ? textFieldWidth : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Warehouse Sales',
            ),
            controller: warehouseSalesController,
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
              context.read<RevenueProvider>().revenueRows[widget.id].warehouseSales =
                  int.parse(newValue!);
            },
          ),
        ),
      ),
      SizedBox(
        width: isWideScreen(context) ? textFieldWidth : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Other Income',
            ),
            controller: otherIncomeController,
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
              context.read<RevenueProvider>().revenueRows[widget.id].otherIncome =
                  int.parse(newValue!);
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            context.read<RevenueProvider>().removeRevenueRow(widget.id);
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
