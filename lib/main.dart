// ============================================
// ФАЙЛ: lib/main.dart
// ЧТО ДЕЛАЕТ: точка входа — только запуск
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  runApp(const ProviderScope(child: MathToolApp()));
}
