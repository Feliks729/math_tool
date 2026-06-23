// ============================================
// ФАЙЛ: lib/core/math_model/triangle.dart
// ЧАСТЬ ПЛАНА: 1.3 — Геометрические объекты
// ЧТО ДЕЛАЕТ: треугольник по трём точкам
// ЗАВИСИТ ОТ: math_figure.dart, math_point.dart, math_segment.dart, math_angle.dart, constants.dart
// ============================================

import 'dart:math';

import '../constants.dart';
import 'math_angle.dart';
import 'math_figure.dart';
import 'math_point.dart';
import 'math_segment.dart';

class Triangle extends MathFigure {
  final MathPoint pointA;
  final MathPoint pointB;
  final MathPoint pointC;

  const Triangle({
    required this.pointA,
    required this.pointB,
    required this.pointC,
    super.isSelected,
    super.color,
  });

  // Площадь по формуле Герона
  @override
  double area() {
    final a = pointB.distanceTo(pointC);
    final b = pointA.distanceTo(pointC);
    final c = pointA.distanceTo(pointB);
    final s = (a + b + c) / 2;
    return sqrt((s * (s - a) * (s - b) * (s - c)).abs());
  }

  // Периметр — сумма трёх сторон
  @override
  double perimeter() {
    return pointA.distanceTo(pointB) +
        pointB.distanceTo(pointC) +
        pointC.distanceTo(pointA);
  }

  // Принадлежность точки треугольнику через барицентрические координаты
  @override
  bool contains(MathPoint p) {
    final d1 = _sign(p, pointA, pointB);
    final d2 = _sign(p, pointB, pointC);
    final d3 = _sign(p, pointC, pointA);
    final hasNeg = d1 < 0 || d2 < 0 || d3 < 0;
    final hasPos = d1 > 0 || d2 > 0 || d3 > 0;
    return !(hasNeg && hasPos);
  }

  double _sign(MathPoint p, MathPoint a, MathPoint b) =>
      (p.x - b.x) * (a.y - b.y) - (a.x - b.x) * (p.y - b.y);

  // Три угла треугольника
  Map<String, MathAngle> angles() => {
        'A': MathAngle(
          vertex: pointA,
          pointA: pointB,
          pointB: pointC,
        ),
        'B': MathAngle(
          vertex: pointB,
          pointA: pointA,
          pointB: pointC,
        ),
        'C': MathAngle(
          vertex: pointC,
          pointA: pointA,
          pointB: pointB,
        ),
      };

  // Три стороны треугольника
  Map<String, MathSegment> sides() => {
        'AB': MathSegment(start: pointA, end: pointB),
        'BC': MathSegment(start: pointB, end: pointC),
        'CA': MathSegment(start: pointC, end: pointA),
      };

  // Тип треугольника по длинам сторон
  String type() {
    final ab = pointA.distanceTo(pointB);
    final bc = pointB.distanceTo(pointC);
    final ca = pointC.distanceTo(pointA);

    if ((ab - bc).abs() < kEpsilon && (bc - ca).abs() < kEpsilon) {
      return 'равносторонний';
    }
    if ((ab - bc).abs() < kEpsilon ||
        (bc - ca).abs() < kEpsilon ||
        (ab - ca).abs() < kEpsilon) {
      return 'равнобедренный';
    }
    return 'разносторонний';
  }

  // Прямоугольный ли треугольник — проверяем все три угла
  bool isRight() => angles().values.any((a) => a.isRight());

  @override
  String toString() => 'Triangle($pointA, $pointB, $pointC)';
}
