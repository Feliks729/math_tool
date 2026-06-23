// ============================================
// ФАЙЛ: lib/core/math_model/point_object.dart
// ЧАСТЬ ПЛАНА: 2.6 — Объект точки на поле
// ЧТО ДЕЛАЕТ: MathObject-обёртка над MathPoint для хранения в состоянии поля
// ЗАВИСИТ ОТ: math_object.dart, math_point.dart, constants.dart
// ============================================

import 'math_object.dart';
import 'math_point.dart';

class PointObject extends MathObject {
  final MathPoint point;

  PointObject({
    required this.point,
    super.isVisible,
    super.isSelected,
    super.id,
  }) : super(type: MathObjectType.point);

  // Ограничивающий прямоугольник — маленькая область вокруг точки
  @override
  BoundingBox boundingBox() => (
        minX: point.x - 0.3,
        minY: point.y - 0.3,
        maxX: point.x + 0.3,
        maxY: point.y + 0.3,
      );

  @override
  String toString() => 'PointObject($point)';
}
