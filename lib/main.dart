import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upturn_dashboard/firebase_options.dart';
import 'package:upturn_dashboard/themes/theme.dart';
import 'package:url_strategy/url_strategy.dart';

import 'router/go_router.dart';

SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;
    systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Upturn Dashboard",
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
    );
  }
}
