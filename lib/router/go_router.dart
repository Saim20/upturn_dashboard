// GoRouter configuration
import 'package:go_router/go_router.dart';
import 'package:upturn_dashboard/pages/expense_entry.dart';
import 'package:upturn_dashboard/pages/expense_table.dart';

import '../pages/shell.dart';

final router = GoRouter(
  initialLocation: '/expenses',
  routes: [
    ShellRoute(
      builder: (context, state, child) => Shell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ExpenseEntryPage(),
        ),
        GoRoute(
          path: '/expenses',
          builder: (context, state) => const ExpenseTablePage(),
        ),
      ],
    ),
  ],
);
