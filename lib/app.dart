// ============================================
// ФАЙЛ: lib/app.dart
// ЧТО ДЕЛАЕТ: корень приложения, тема, маршруты
// ============================================

import 'package:flutter/material.dart';

import 'field/grid_field.dart';
import 'keyboard/keyboard_controller.dart';
import 'keyboard/math_keyboard.dart';

class MathToolApp extends StatelessWidget {
  const MathToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  final _keyboardController = KeyboardController();

  @override
  void dispose() {
    _keyboardController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    debugPrint('Выражение: ${_keyboardController.expression}');
    debugPrint('LaTeX: ${_keyboardController.latex}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Поле занимает всё доступное пространство
          const Expanded(child: GridField()),

          // Клавиатура фиксированной высоты снизу
          MathKeyboard(
            controller: _keyboardController,
            onConfirm: _onConfirm,
          ),
        ],
      ),
    );
  }
}
