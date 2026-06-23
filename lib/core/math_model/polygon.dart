// ============================================
// ФАЙЛ: lib/core/math_model/polygon.dart
// ЧАСТЬ ПЛАНА: 1.3 — Геометрические объекты
// ЧТО ДЕЛАЕТ: произвольный многоугольник по списку вершин
// ЗАВИСИТ ОТ: math_figure.dart, math_point.dart, math_segment.dart, constants.dart
// ============================================

import '../constants.dart';
import 'math_figure.dart';
import 'math_point.dart';
import 'math_segment.dart';

class Polygon extends MathFigure {
  /// Вершины многоугольника в порядке обхода
  final List<MathPoint> points;

  const Polygon({
    required this.points,
    super.isSelected,
    super.color,
  });

  // Площадь по формуле Гаусса (shoelace formula)
  @override
  double area() {
    final n = points.length;
    if (n < 3) return 0.0;
    double sum = 0.0;
    for (var i = 0; i < n; i++) {
      final j = (i + 1) % n;
      sum += points[i].x * points[j].y;
      sum -= points[j].x * points[i].y;
    }
    return sum.abs() / 2;
  }

  // Периметр — сумма длин всех сторон
  @override
  double perimeter() {
    final n = points.length;
    if (n < 2) return 0.0;
    double total = 0.0;
    for (var i = 0; i < n; i++) {
      total += points[i].distanceTo(points[(i + 1) % n]);
    }
    return total;
  }

  // Принадлежность точки многоугольнику — алгоритм ray casting
  @override
  bool contains(MathPoint p) {
    final n = points.length;
    if (n < 3) return false;
    bool inside = false;
    var j = n - 1;
    for (var i = 0; i < n; i++) {
      final xi = points[i].x;
      final yi = points[i].y;
      final xj = points[j].x;
      final yj = points[j].y;

      final intersects = ((yi > p.y) != (yj > p.y)) &&
          (p.x < (xj - xi) * (p.y - yi) / (yj - yi) + xi);
      if (intersects) inside = !inside;
      j = i;
    }
    return inside;
  }

  // Список сторон многоугольника
  List<MathSegment> sides() {
    final n = points.length;
    return List.generate(
      n,
      (i) => MathSegment(start: points[i], end: points[(i + 1) % n]),
    );
  }

  // Выпуклый ли многоугольник — знак векторного произведения одинаков для всех вершин
  bool isConvex() {
    final n = points.length;
    if (n < 3) return false;
    int? sign;
    for (var i = 0; i < n; i++) {
      final a = points[i];
      final b = points[(i + 1) % n];
      final c = points[(i + 2) % n];
      final cross = (b.x - a.x) * (c.y - b.y) - (b.y - a.y) * (c.x - b.x);
      if (cross.abs() < kEpsilon) continue;
      final s = cross > 0 ? 1 : -1;
      if (sign == null) {
        sign = s;
      } else if (sign != s) {
        return false;
      }
    }
    return true;
  }

  @override
  String toString() => 'Polygon(${points.length} вершин, площадь: ${area().toStringAsFixed(2)})';
}
