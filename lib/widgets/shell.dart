import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:upturn_dashboard/functions/responsiveness.dart';

// Shell widget for containing the destinations
class Shell extends StatefulWidget {
  const Shell({super.key, required this.child});

  final Widget child;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  String selected = '/expenses';

  Map<String, Icon> mainDestinations = {
    '/expenses': const Icon(Icons.money_off_csred_outlined),
    '/revenue': const Icon(Icons.attach_money_outlined),
  };

  Map<String, Icon> constantDestinations = {
    '/settings': const Icon(Icons.settings),
    '/login': const Icon(Icons.login_outlined),
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
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text('Upturn Dashboard'),
        leading: const Icon(Icons.monitor),
        actions: [
          if (isWideScreen(context)) ...actionElements,
          PopupMenuButton<String>(onSelected: (value) {
            selected = value;
            context.go(value);
          }, itemBuilder: (BuildContext context) {
            List<PopupMenuEntry<String>> items = [];

            if (!isWideScreen(context)) {
              items.addAll(mainDestinations.keys.map((String key) {
                return PopupMenuItem<String>(
                  value: key,
                  onTap: () => context.go(key),
                  child: Row(
                    children: [
                      mainDestinations[key]!,
                      Text(
                          key.substring(1)[0].toUpperCase() + key.substring(2)),
                    ],
                  ),
                );
              }).toList());

              items.add(const PopupMenuDivider());
            }

            items.addAll(constantDestinations.keys.map((String key) {
              return PopupMenuItem<String>(
                value: key,
                onTap: () => context.go(key),
                child: Row(
                  children: [
                    constantDestinations[key]!,
                    Text(key.substring(1)[0].toUpperCase() + key.substring(2)),
                  ],
                ),
              );
            }).toList());

            return items;
          }),
        ],
        // ...
      ),
      body: Column(
        children: [
          Expanded(child: widget.child),
          if(isWideScreen(context))
          Container(
            height: 70, 
            color: Theme.of(context).colorScheme.onSecondary,
            child: const Center(
                child: Text('Footer')),
          ),
        ],
      ),
    );
  }
}
