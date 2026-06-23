// ============================================
// ФАЙЛ: lib/field/layers/annotations_layer.dart
// ЧАСТЬ ПЛАНА: 2.4 — Слои поля
// ЧТО ДЕЛАЕТ: слой аннотаций — подписи, размеры, углы
// ЗАВИСИТ ОТ: math_object.dart, grid_controller.dart
// ============================================

import 'package:flutter/material.dart';

import '../../core/math_model/math_object.dart';
import '../grid_controller.dart';

class AnnotationsLayer extends CustomPainter {
  final List<MathObject> objects;
  final GridController controller;

  /// Можно скрыть все аннотации одним флагом
  final bool isVisible;

  const AnnotationsLayer({
    required this.objects,
    required this.controller,
    this.isVisible = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Заполняется по мере добавления объектов с аннотациями
  }

  @override
  bool shouldRepaint(AnnotationsLayer oldDelegate) =>
      oldDelegate.objects != objects || oldDelegate.isVisible != isVisible;
}
