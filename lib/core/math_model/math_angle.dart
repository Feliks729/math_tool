// ============================================
// ФАЙЛ: lib/core/math_model/math_angle.dart
// ЧАСТЬ ПЛАНА: 1.2 — Базовые типы данных
// ЧТО ДЕЛАЕТ: угол образованный тремя точками
// ЗАВИСИТ ОТ: math_point.dart, constants.dart
// ============================================

import 'dart:math';

import '../constants.dart';
import 'math_point.dart';

class MathAngle {
  /// Вершина угла
  final MathPoint vertex;

  /// Первая точка (луч VA)
  final MathPoint pointA;

  /// Вторая точка (луч VB)
  final MathPoint pointB;

  const MathAngle({
    required this.vertex,
    required this.pointA,
    required this.pointB,
  });

  // Величина угла в радианах через скалярное произведение векторов
  double radians() {
    final ax = pointA.x - vertex.x;
    final ay = pointA.y - vertex.y;
    final bx = pointB.x - vertex.x;
    final by = pointB.y - vertex.y;

    final dot = ax * bx + ay * by;
    final lenA = sqrt(ax * ax + ay * ay);
    final lenB = sqrt(bx * bx + by * by);

    // Защита от деления на ноль — если одна из точек совпадает с вершиной
    if (lenA < kEpsilon || lenB < kEpsilon) return 0.0;

    // Зажимаем в [-1, 1] чтобы избежать NaN из-за погрешностей
    final cosAngle = (dot / (lenA * lenB)).clamp(-1.0, 1.0);
    return acos(cosAngle);
  }

  // Величина угла в градусах
  double degrees() => radians() * 180 / pi;

  // Прямой угол — 90° с точностью kEpsilon
  bool isRight() => (radians() - pi / 2).abs() < kEpsilon;

  // Острый угол — меньше 90°
  bool isAcute() => radians() < pi / 2 - kEpsilon;

  // Тупой угол — больше 90°
  bool isObtuse() => radians() > pi / 2 + kEpsilon;

  @override
  bool operator ==(Object other) {
    if (other is! MathAngle) return false;
    return vertex == other.vertex &&
        pointA == other.pointA &&
        pointB == other.pointB;
  }

  @override
  int get hashCode => Object.hash(vertex, pointA, pointB);

  @override
  String toString() {
    final a = pointA.label.isNotEmpty ? pointA.label : '?';
    final v = vertex.label.isNotEmpty ? vertex.label : '?';
    final b = pointB.label.isNotEmpty ? pointB.label : '?';
    return '∠$a$v$b = ${degrees().toStringAsFixed(1)}°';
  }
}
