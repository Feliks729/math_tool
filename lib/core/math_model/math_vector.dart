// ============================================
// ФАЙЛ: lib/core/math_model/math_vector.dart
// ЧАСТЬ ПЛАНА: 1.3 — Геометрические объекты
// ЧТО ДЕЛАЕТ: вектор на плоскости
// ЗАВИСИТ ОТ: math_point.dart, constants.dart
// ============================================

import 'dart:math';

import '../constants.dart';
import 'math_point.dart';

class MathVector {
  final MathPoint start;
  final MathPoint end;

  const MathVector({required this.start, required this.end});

  // Проекция вектора на ось X
  double dx() => end.x - start.x;

  // Проекция вектора на ось Y
  double dy() => end.y - start.y;

  // Длина вектора
  double length() => sqrt(dx() * dx() + dy() * dy());

  // Скалярное произведение двух векторов
  double dotProduct(MathVector other) =>
      dx() * other.dx() + dy() * other.dy();

  // Угол между двумя векторами в градусах
  double angleTo(MathVector other) {
    final lenA = length();
    final lenB = other.length();
    if (lenA < kEpsilon || lenB < kEpsilon) return 0.0;
    final cosAngle = (dotProduct(other) / (lenA * lenB)).clamp(-1.0, 1.0);
    return acos(cosAngle) * 180 / pi;
  }

  @override
  bool operator ==(Object other) {
    if (other is! MathVector) return false;
    return start == other.start && end == other.end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() {
    final label = start.label.isNotEmpty && end.label.isNotEmpty
        ? '${start.label}${end.label} '
        : '';
    return '→$label(${dx().toStringAsFixed(1)}, ${dy().toStringAsFixed(1)})';
  }
}
