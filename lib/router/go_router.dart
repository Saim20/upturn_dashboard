// GoRouter configuration
import 'package:go_router/go_router.dart';
import 'package:upturn_dashboard/pages/home.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (_, state) => const HomePage(),
    ),
  ],
);