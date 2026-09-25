import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_nav_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SurfaceAreaCalculatorApp());
}

class SurfaceAreaCalculatorApp extends StatelessWidget {
  const SurfaceAreaCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surface Area Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Supports automatic system dark/light theme
      home: const MainNavScreen(),
    );
  }
}
