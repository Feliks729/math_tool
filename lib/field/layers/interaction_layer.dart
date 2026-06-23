// ============================================
// ФАЙЛ: lib/field/layers/interaction_layer.dart
// ЧАСТЬ ПЛАНА: 2.4 — Слои поля
// ЧТО ДЕЛАЕТ: слой интерактива — выделение и превью при построении
// ЗАВИСИТ ОТ: math_object.dart, grid_controller.dart, constants.dart
// ============================================

import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/math_model/math_object.dart';
import '../grid_controller.dart';

class InteractionLayer extends CustomPainter {
  final MathObject? selectedObject;
  final MathObject? previewObject;
  final GridController controller;

  const InteractionLayer({
    required this.controller,
    this.selectedObject,
    this.previewObject,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedObject != null) {
      _drawSelectionBox(canvas, selectedObject!);
    }
    if (previewObject != null) {
      _drawSelectionBox(canvas, previewObject!);
    }
  }

  // Рисует прямоугольник подсветки вокруг boundingBox объекта
  void _drawSelectionBox(Canvas canvas, MathObject obj) {
    final box = obj.boundingBox();

    final topLeft = controller.fieldToScreen(Offset(box.minX, box.maxY));
    final bottomRight = controller.fieldToScreen(Offset(box.maxX, box.minY));

    final rect = Rect.fromPoints(topLeft, bottomRight);

    // Полупрозрачная заливка
    canvas.drawRect(
      rect,
      Paint()..color = kColorSelection.withValues(alpha: 0.3),
    );

    // Контур
    canvas.drawRect(
      rect,
      Paint()
        ..color = kColorSelection
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(InteractionLayer oldDelegate) =>
      oldDelegate.selectedObject != selectedObject ||
      oldDelegate.previewObject != previewObject;
}
