// GoRouter configuration
import 'package:go_router/go_router.dart';
import 'package:upturn_dashboard/pages/not_found.dart';
import 'package:upturn_dashboard/pages/expenses/expenses_entry.dart';
import 'package:upturn_dashboard/pages/expenses/expenses_list.dart';
import 'package:upturn_dashboard/pages/expenses/main_expenses.dart';
import 'package:upturn_dashboard/pages/login.dart';
import 'package:upturn_dashboard/pages/revenue/main_revenue.dart';
import 'package:upturn_dashboard/pages/settings.dart';

import '../widgets/shell.dart';

final router = GoRouter(
  initialLocation: '/expenses',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    ShellRoute(
      builder: (context, state, child) => Shell(child: child),
      routes: [
        GoRoute(
          path: '/expenses',
          builder: (context, state) => const ExpensesMainPage(),
        ),
        GoRoute(
          path: '/expenses/entry',
          builder: (context, state) => const ExpenseEntryPage(),
        ),
        GoRoute(
          path: '/expenses/list',
          builder: (context, state) => const ExpenseListPage(),
        ),
        GoRoute(
          path: '/revenue',
          builder: (context, state) => const RevenueMainPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
      ],
    ),
  ],
);
