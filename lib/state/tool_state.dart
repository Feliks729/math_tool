// ============================================
// ФАЙЛ: lib/state/tool_state.dart
// ЧАСТЬ ПЛАНА: 2.5 — Глобальное состояние поля
// ЧТО ДЕЛАЕТ: хранит активный инструмент пользователя
// ЗАВИСИТ ОТ: riverpod
// ============================================

import 'package:riverpod/riverpod.dart';

// Все доступные инструменты
enum ActiveTool {
  select,      // выделение и перемещение объектов
  point,       // поставить точку
  segment,     // нарисовать отрезок
  triangle,    // построить треугольник
  circle,      // построить окружность
  polygon,     // построить многоугольник
  function,    // построить график функции
  numberLine,  // числовая прямая
}

// По умолчанию — режим выделения
final activeToolProvider = StateProvider<ActiveTool>(
  (ref) => ActiveTool.select,
);
