
import 'package:estapps/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

// نقطة البداية للتطبيق
void main() {
  runApp(const EstApp());
}

class EstApp extends StatelessWidget {
  const EstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: const WelcomeScreen(),
    );
  }
}