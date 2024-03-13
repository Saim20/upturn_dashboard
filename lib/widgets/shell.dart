import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Shell widget for containing the destinations
class Shell extends StatefulWidget {
  const Shell({super.key, required this.child});

  final Widget child;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  String selected = '/expenses';
  bool isWide = false;

  Map<String, Icon> mainDestinations = {
    '/expenses': const Icon(Icons.money_off_csred_outlined),
    '/revenue': const Icon(Icons.attach_money_outlined),
  };

  List<Widget> actionElements = [];

  @override
  Widget build(BuildContext context) {
    actionElements = [];

    mainDestinations.forEach((key, value) {
      actionElements.add(
        TextButton.icon(
          icon: value,
          label: Text(key.substring(1)[0].toUpperCase() + key.substring(2)),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith(
              (states) {
                if (selected == key) {
                  return Colors.white;
                }
                return null;
              },
            ),
          ),
          onPressed: () {
            selected = key;
            context.go(key);
          },
        ),
      );
    });
    return Scaffold(
      // * Use the child provided by go_router
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text('Upturn Dashboard'),
        leading: const Icon(Icons.monitor),
        actions: actionElements,
      ),
      body: Row(
        children: [
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
