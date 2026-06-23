// ============================================
// ФАЙЛ: lib/core/math_model/number_line.dart
// ЧАСТЬ ПЛАНА: 1.2 — Базовые типы данных
// ЧТО ДЕЛАЕТ: числовая прямая с точками и интервалами
// ЗАВИСИТ ОТ: math_inequality.dart, constants.dart
// ============================================

import '../constants.dart';
import 'math_inequality.dart';

// Отдельная точка на числовой прямой
class NumberLinePoint {
  final double value;

  /// true — закрашенная точка (включена), false — незакрашенная (исключена)
  final bool isIncluded;
  final String label;

  const NumberLinePoint({
    required this.value,
    this.isIncluded = true,
    this.label = '',
  });

  @override
  String toString() {
    final mark = isIncluded ? '●' : '○';
    return '$mark${label.isNotEmpty ? label : value}';
  }
}

// Интервал на числовой прямой
class NumberLineInterval {
  final NumberLinePoint start;
  final NumberLinePoint end;

  const NumberLineInterval({required this.start, required this.end});

  // Проверяет входит ли значение x в интервал
  bool containsValue(double x) {
    final afterStart = start.isIncluded
        ? x >= start.value - kEpsilon
        : x > start.value + kEpsilon;
    final beforeEnd = end.isIncluded
        ? x <= end.value + kEpsilon
        : x < end.value - kEpsilon;
    return afterStart && beforeEnd;
  }

  @override
  String toString() {
    final l = start.isIncluded ? '[' : '(';
    final r = end.isIncluded ? ']' : ')';
    return '$l${start.value}; ${end.value}$r';
  }
}

// Числовая прямая — набор точек и интервалов
class NumberLine {
  final List<NumberLinePoint> points;
  final List<NumberLineInterval> intervals;

  NumberLine({
    List<NumberLinePoint>? points,
    List<NumberLineInterval>? intervals,
  })  : points = points ?? [],
        intervals = intervals ?? [];

  void addPoint(NumberLinePoint p) => points.add(p);

  void addInterval(NumberLineInterval i) => intervals.add(i);

  // Построить числовую прямую из неравенства
  static NumberLine fromInequality(MathInequality inequality) {
    final line = NumberLine();
    for (final sol in inequality.solutionIntervals()) {
      line.addInterval(NumberLineInterval(
        start: NumberLinePoint(
          value: sol.start,
          isIncluded: sol.startIncluded,
        ),
        end: NumberLinePoint(
          value: sol.end,
          isIncluded: sol.endIncluded,
        ),
      ));
    }
    return line;
  }

  // Объединение двух числовых прямых — все точки и интервалы обеих
  NumberLine union(NumberLine other) {
    return NumberLine(
      points: [...points, ...other.points],
      intervals: [...intervals, ...other.intervals],
    );
  }

  // Пересечение — только те значения которые входят в обе прямые
  // Ищем перебором в диапазоне [-10, 10] и строим новые интервалы
  NumberLine intersection(NumberLine other) {
    const xMin = -10.0;
    const xMax = 10.0;
    final result = NumberLine();

    bool inInterval = false;
    double intervalStart = xMin;
    bool startIncluded = false;

    var x = xMin;
    while (x <= xMax + kPlotStep / 2) {
      final inA = _containsValue(x);
      final inB = other._containsValue(x);
      final inBoth = inA && inB;

      if (inBoth && !inInterval) {
        inInterval = true;
        intervalStart = x;
        startIncluded = true;
      } else if (!inBoth && inInterval) {
        final intervalEnd = x - kPlotStep;
        result.addInterval(NumberLineInterval(
          start: NumberLinePoint(value: intervalStart, isIncluded: startIncluded),
          end: NumberLinePoint(value: intervalEnd, isIncluded: true),
        ));
        inInterval = false;
      }

      x += kPlotStep;
    }

    if (inInterval) {
      result.addInterval(NumberLineInterval(
        start: NumberLinePoint(value: intervalStart, isIncluded: startIncluded),
        end: const NumberLinePoint(value: 10.0, isIncluded: true),
      ));
    }

    return result;
  }

  // Проверяет входит ли x хотя бы в один интервал или точку этой прямой
  bool _containsValue(double x) {
    for (final interval in intervals) {
      if (interval.containsValue(x)) return true;
    }
    for (final point in points) {
      if ((point.value - x).abs() < kEpsilon) return true;
    }
    return false;
  }

  @override
  String toString() {
    final parts = [
      ...intervals.map((i) => i.toString()),
      ...points.map((p) => p.toString()),
    ];
    return parts.isEmpty ? '∅' : parts.join(' ∪ ');
  }
}
