import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upturn_dashboard/functions/responsiveness.dart';
import 'package:upturn_dashboard/provider/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _age;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upturn Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ChangeNotifierProvider(
                create: (context) => DataProvider(),
                builder: (context, child) => Text(
                  context.watch<DataProvider>().paymentMethods.toString(),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // Date Picker
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            setState(() {
                              _selectedDate = selectedDate;
                            });
                          }
                        });
                      },
                      child: Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : _selectedDate!.toIso8601String(),
                      ),
                    ),
                  ),

                  // Age Text Field
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Age',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      int? age = int.tryParse(value);
                      if (age == null) {
                        return 'Please enter a valid number';
                      } else if (age < 0) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _age = value;
                      });
                    },
                  ),

                  // Submit Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process form data
                          print('Date: $_selectedDate, Age: $_age');
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
