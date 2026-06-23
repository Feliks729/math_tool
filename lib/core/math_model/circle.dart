// ============================================
// ФАЙЛ: lib/core/math_model/circle.dart
// ЧАСТЬ ПЛАНА: 1.3 — Геометрические объекты
// ЧТО ДЕЛАЕТ: окружность с центром и радиусом
// ЗАВИСИТ ОТ: math_figure.dart, math_point.dart, constants.dart
// ============================================

import 'dart:math';

import '../constants.dart';
import 'math_figure.dart';
import 'math_point.dart';

class Circle extends MathFigure {
  final MathPoint center;
  final double radius;

  const Circle({
    required this.center,
    required this.radius,
    super.isSelected,
    super.color,
  });

  // Площадь круга
  @override
  double area() => pi * radius * radius;

  // Длина окружности
  @override
  double perimeter() => 2 * pi * radius;

  // Точка внутри круга (включая границу)
  @override
  bool contains(MathPoint p) =>
      center.distanceTo(p) <= radius + kEpsilon;

  // Точка лежит на окружности
  bool containsOnBoundary(MathPoint p) =>
      (center.distanceTo(p) - radius).abs() < kEpsilon;

  // Пересечение двух окружностей — проверяем расстояние между центрами
  bool intersectsWith(Circle other) {
    final d = center.distanceTo(other.center);
    final rSum = radius + other.radius;
    final rDiff = (radius - other.radius).abs();
    // Пересекаются если расстояние между центрами в диапазоне [|r1-r2|, r1+r2]
    return d <= rSum + kEpsilon && d >= rDiff - kEpsilon;
  }

  @override
  String toString() =>
      'Circle(center: $center, r: ${radius.toStringAsFixed(2)})';
}
