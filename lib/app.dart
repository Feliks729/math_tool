// ============================================
// ФАЙЛ: lib/app.dart
// ЧТО ДЕЛАЕТ: корень приложения, тема, маршруты
// ============================================

import 'package:flutter/material.dart';

import 'field/grid_field.dart';

class MathToolApp extends StatelessWidget {
  const MathToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: GridField(),
      ),
    );
  }
}
