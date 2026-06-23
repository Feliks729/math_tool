// ============================================
// ФАЙЛ: lib/core/math_model/math_segment.dart
// ЧАСТЬ ПЛАНА: 1.2 — Базовые типы данных
// ЧТО ДЕЛАЕТ: отрезок между двумя точками
// ЗАВИСИТ ОТ: math_point.dart, constants.dart
// ============================================

import '../constants.dart';
import 'math_point.dart';

class MathSegment {
  final MathPoint start;
  final MathPoint end;

  const MathSegment({required this.start, required this.end});

  // Длина отрезка
  double length() => start.distanceTo(end);

  // Середина отрезка
  MathPoint midpoint() => start.midpointTo(end);

  // Проверяет лежит ли точка p на отрезке
  // Метод: сумма расстояний p→start и p→end равна длине отрезка
  bool containsPoint(MathPoint p) {
    final d = length();
    if (d < kEpsilon) return p == start;
    return (p.distanceTo(start) + p.distanceTo(end) - d).abs() < kEpsilon;
  }

  // Находит точку пересечения двух отрезков или возвращает null
  // Метод: параметрическое уравнение для двух отрезков
  MathPoint? intersectsWith(MathSegment other) {
    final dx1 = end.x - start.x;
    final dy1 = end.y - start.y;
    final dx2 = other.end.x - other.start.x;
    final dy2 = other.end.y - other.start.y;

    final denom = dx1 * dy2 - dy1 * dx2;

    // Отрезки параллельны или совпадают
    if (denom.abs() < kEpsilon) return null;

    final dx3 = other.start.x - start.x;
    final dy3 = other.start.y - start.y;

    final t = (dx3 * dy2 - dy3 * dx2) / denom;
    final u = (dx3 * dy1 - dy3 * dx1) / denom;

    // Пересечение только если оба параметра в диапазоне [0, 1]
    if (t < -kEpsilon || t > 1 + kEpsilon) return null;
    if (u < -kEpsilon || u > 1 + kEpsilon) return null;

    return MathPoint(
      x: start.x + t * dx1,
      y: start.y + t * dy1,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! MathSegment) return false;
    return (start == other.start && end == other.end) ||
        (start == other.end && end == other.start);
  }

  @override
  int get hashCode => Object.hashAll([start, end].map((p) => p.hashCode).toList()..sort());

  @override
  String toString() => 'MathSegment($start → $end, length: ${length().toStringAsFixed(2)})';
}
