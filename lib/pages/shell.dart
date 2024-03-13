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
  int selected = 0;
  bool isWide = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // * Use the child provided by go_router
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text('Upturn Dashboard'),
        leading: const Icon(Icons.monitor),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.input),
              onPressed: () {
                // Navigate to settings page with go_router
                context.go('/');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.table_chart_outlined),
              onPressed: () {
                // Navigate to settings page with go_router
                context.go('/expenses');
              },
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
