// ============================================
// ФАЙЛ: lib/core/math_model/math_function.dart
// ЧАСТЬ ПЛАНА: 1.4 — Алгебраические объекты
// ЧТО ДЕЛАЕТ: функция f(x) с формулой, цветом и методами анализа
// ЗАВИСИТ ОТ: math_expression.dart, constants.dart
// ============================================

import 'package:flutter/material.dart';

import '../constants.dart';
import 'math_expression.dart';
import 'math_point.dart';

class MathFunction {
  final MathExpression expression;
  final Color color;
  final bool isVisible;

  const MathFunction({
    required this.expression,
    this.color = kColorPoint,
    this.isVisible = true,
  });

  // Значение функции в точке x, null если вне области определения
  double? valueAt(double x) => expression.evaluate(x);

  // Список точек для построения графика в диапазоне [xMin, xMax]
  // Разрывы графика обозначаются отсутствием точки (null пропускается)
  List<MathPoint> pointsInRange(double xMin, double xMax) {
    final points = <MathPoint>[];
    var x = xMin;
    while (x <= xMax + kPlotStep / 2) {
      final y = valueAt(x);
      if (y != null) {
        points.add(MathPoint(x: x, y: y));
      }
      x += kPlotStep;
    }
    return points;
  }

  // Нули функции в диапазоне [-10, 10] — ищем смену знака методом перебора
  List<double> zeros() {
    const xMin = -10.0;
    const xMax = 10.0;
    final result = <double>[];

    var x = xMin;
    double? prevY = valueAt(x);

    while (x < xMax) {
      x += kPlotStep;
      final currY = valueAt(x);

      if (prevY != null && currY != null) {
        // Смена знака означает что где-то здесь ноль
        if (prevY * currY < 0) {
          // Уточняем методом деления пополам
          final zero = _bisect(x - kPlotStep, x);
          if (zero != null) result.add(zero);
        } else if (currY.abs() < kEpsilon) {
          // Функция точно равна нулю в текущей точке
          result.add(x);
        }
      }

      prevY = currY;
    }

    return result;
  }

  // Метод деления пополам для уточнения нуля на отрезке [a, b]
  double? _bisect(double a, double b) {
    for (var i = 0; i < 50; i++) {
      final mid = (a + b) / 2;
      final fMid = valueAt(mid);
      final fA = valueAt(a);
      if (fMid == null || fA == null) return null;
      if (fMid.abs() < kEpsilon) return mid;
      if (fA * fMid < 0) {
        b = mid;
      } else {
        a = mid;
      }
    }
    return (a + b) / 2;
  }

  // Область определения — пока возвращаем ℝ для всех функций
  String domain() => 'ℝ';

  @override
  String toString() => 'MathFunction(f(x) = ${expression.expression})';
}
