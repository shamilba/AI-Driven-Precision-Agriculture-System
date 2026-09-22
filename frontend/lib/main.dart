import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const AgricultureApp());
}

class AgricultureApp extends StatelessWidget {
  const AgricultureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI-Driven Precision Agriculture',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}