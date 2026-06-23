// ============================================
// ФАЙЛ: lib/core/math_model/math_point.dart
// ЧАСТЬ ПЛАНА: 1.2 — Базовые типы данных
// ЧТО ДЕЛАЕТ: базовый объект точки на поле
// ЗАВИСИТ ОТ: constants.dart
// ============================================

import 'dart:math';

import '../../core/constants.dart';

class MathPoint {
  final double x;
  final double y;

  /// Метка точки (A, B, C...) — пустая строка если метка не нужна
  final String label;

  const MathPoint({
    required this.x,
    required this.y,
    this.label = '',
  });

  // Расстояние до другой точки по теореме Пифагора
  double distanceTo(MathPoint other) {
    return sqrt(pow(other.x - x, 2) + pow(other.y - y, 2));
  }

  // Середина отрезка между двумя точками
  MathPoint midpointTo(MathPoint other) {
    return MathPoint(
      x: (x + other.x) / 2,
      y: (y + other.y) / 2,
    );
  }

  // Копия точки с изменёнными полями
  MathPoint copyWith({double? x, double? y, String? label}) {
    return MathPoint(
      x: x ?? this.x,
      y: y ?? this.y,
      label: label ?? this.label,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! MathPoint) return false;
    return (x - other.x).abs() < kEpsilon && (y - other.y).abs() < kEpsilon;
  }

  @override
  int get hashCode => Object.hash(
        (x / kEpsilon).round(),
        (y / kEpsilon).round(),
      );

  @override
  String toString() => 'MathPoint(${label.isNotEmpty ? "$label: " : ""}$x, $y)';
}
