// ============================================
// ФАЙЛ: lib/app.dart
// ЧТО ДЕЛАЕТ: корень приложения, тема, маршруты
// ============================================

import 'package:flutter/material.dart';

class MathToolApp extends StatelessWidget {
  const MathToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Math Tool',
      home: Scaffold(
        body: Center(
          child: Text('Math Tool'),
        ),
      ),
    );
  }
}
