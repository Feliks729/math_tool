// ============================================
// ФАЙЛ: lib/field/layers/objects_layer.dart
// ЧАСТЬ ПЛАНА: 2.4 / 2.6 — Слой объектов
// ЧТО ДЕЛАЕТ: рисует объекты поля — точки и будущие фигуры
// ЗАВИСИТ ОТ: math_object.dart, point_object.dart, grid_controller.dart, constants.dart
// ============================================

import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/math_model/math_object.dart';
import '../../core/math_model/point_object.dart';
import '../grid_controller.dart';

class ObjectsLayer extends CustomPainter {
  final List<MathObject> objects;
  final GridController controller;

  const ObjectsLayer({
    required this.objects,
    required this.controller,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final obj in objects) {
      if (!obj.isVisible) continue;

      if (obj is PointObject) {
        _drawPoint(canvas, obj);
      }
      // Другие типы объектов добавляются здесь по мере разработки режимов
    }
  }

  // Рисует точку: закрашенный круг + метка
  void _drawPoint(Canvas canvas, PointObject obj) {
    final screen = controller.fieldToScreen(
      Offset(obj.point.x, obj.point.y),
    );

    // Закрашенный круг
    canvas.drawCircle(
      screen,
      4.0,
      Paint()..color = obj.isSelected ? kColorSelection : kColorPoint,
    );

    // Тонкий белый контур чтобы точка была видна на сетке
    canvas.drawCircle(
      screen,
      4.0,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Метка рядом с точкой
    if (obj.point.label.isNotEmpty) {
      final tp = TextPainter(
        text: TextSpan(
          text: obj.point.label,
          style: const TextStyle(
            color: kColorPoint,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, screen + const Offset(6, -14));
    }
  }

  @override
  bool shouldRepaint(ObjectsLayer oldDelegate) =>
      oldDelegate.objects != objects;
}
