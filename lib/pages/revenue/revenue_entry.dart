import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upturn_dashboard/provider/revenue_provider.dart';
import 'package:upturn_dashboard/widgets/revenue_row.dart';

class RevenueEntryPage extends StatefulWidget {
  const RevenueEntryPage({super.key});

  @override
  State<RevenueEntryPage> createState() => _RevenueEntryPageState();
}

class _RevenueEntryPageState extends State<RevenueEntryPage> {
  final _formKey = GlobalKey<FormState>();
  bool uploading = false;

  DateTime selectedTransactionDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    int rowCount = 0;
    // return MultiProvider(
    //     providers: [
    //       ChangeNotifierProvider(create: (context) => RevenueProvider()),
    //     ],
    //     builder: (context, child) {
    //     });
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: context
                  .watch<RevenueProvider>()
                  .revenueDatas
                  .map((e) => RevenueRow(
                        id: rowCount++,
                        setSelectedDate: (selectedDate) {
                          selectedTransactionDate = selectedDate;
                        },
                      ))
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
                  context
                      .read<RevenueProvider>()
                      .addRevenueRow(selectedTransactionDate);
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
                                        if (_formKey.currentState!.validate()) {
                                          parentContext
                                              .read<RevenueProvider>()
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
  }
}
