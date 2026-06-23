// ============================================
// ФАЙЛ: lib/field/grid_painter.dart
// ЧАСТЬ ПЛАНА: 2.2 — Рендеринг (CustomPainter)
// ЧТО ДЕЛАЕТ: рисует сетку, оси и подписи делений
// ЗАВИСИТ ОТ: grid_controller.dart, grid_settings.dart, constants.dart
// ============================================

import 'package:flutter/material.dart';

import 'grid_controller.dart';

class GridPainter extends CustomPainter {
  final GridController controller;

  GridPainter({required this.controller}) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    // Порядок слоёв: фон → сетка → оси → подписи
    _drawBackground(canvas, size);
    _drawGrid(canvas, size);
    if (controller.settings.showAxes) _drawAxes(canvas, size);
    if (controller.settings.showLabels) _drawLabels(canvas, size);
  }

  // Заливаем фон
  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = controller.settings.backgroundColor,
    );
  }

  // Рисуем линии сетки — только те которые видны на экране
  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = controller.settings.gridColor
      ..strokeWidth = 0.5;

    final cellPx = controller.settings.cellSize * controller.scale;

    // Смещение первой видимой линии относительно начала экрана
    final startX = controller.offsetX % cellPx;
    final startY = controller.offsetY % cellPx;

    // Вертикальные линии
    for (var x = startX; x <= size.width; x += cellPx) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Горизонтальные линии
    for (var y = startY; y <= size.height; y += cellPx) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  // Рисуем оси X и Y со стрелками
  void _drawAxes(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = controller.settings.axisColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Позиция нуля на экране
    final origin = controller.fieldToScreen(Offset.zero);

    const arrowSize = 8.0;

    // Ось X — горизонтальная линия
    if (origin.dy >= 0 && origin.dy <= size.height) {
      canvas.drawLine(
        Offset(0, origin.dy),
        Offset(size.width, origin.dy),
        paint,
      );
      // Стрелка вправо
      _drawArrow(
        canvas, paint,
        Offset(size.width - arrowSize, origin.dy - arrowSize / 2),
        Offset(size.width, origin.dy),
        Offset(size.width - arrowSize, origin.dy + arrowSize / 2),
      );
    }

    // Ось Y — вертикальная линия
    if (origin.dx >= 0 && origin.dx <= size.width) {
      canvas.drawLine(
        Offset(origin.dx, size.height),
        Offset(origin.dx, 0),
        paint,
      );
      // Стрелка вверх
      _drawArrow(
        canvas, paint,
        Offset(origin.dx - arrowSize / 2, arrowSize),
        Offset(origin.dx, 0),
        Offset(origin.dx + arrowSize / 2, arrowSize),
      );
    }
  }

  // Вспомогательный метод — рисует наконечник стрелки из трёх точек
  void _drawArrow(Canvas canvas, Paint paint, Offset a, Offset tip, Offset b) {
    final path = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(b.dx, b.dy);
    canvas.drawPath(path, paint);
  }

  // Рисуем подписи целых чисел на осях
  void _drawLabels(Canvas canvas, Size size) {
    final cellPx = controller.settings.cellSize * controller.scale;
    final origin = controller.fieldToScreen(Offset.zero);

    final textStyle = TextStyle(
      color: controller.settings.axisColor,
      fontSize: 10,
    );

    // Диапазон видимых делений по X
    final xMin = ((-origin.dx) / cellPx).ceil();
    final xMax = ((size.width - origin.dx) / cellPx).floor();

    for (var i = xMin; i <= xMax; i++) {
      if (i == 0) continue;
      final screenX = origin.dx + i * cellPx;
      _drawText(canvas, '$i', Offset(screenX - 6, origin.dy + 4), textStyle);
    }

    // Диапазон видимых делений по Y
    final yMin = ((origin.dy - size.height) / cellPx).ceil();
    final yMax = (origin.dy / cellPx).floor();

    for (var i = yMin; i <= yMax; i++) {
      if (i == 0) continue;
      final screenY = origin.dy - i * cellPx;
      _drawText(canvas, '$i', Offset(origin.dx + 4, screenY - 6), textStyle);
    }
  }

  // Отрисовка текста через TextPainter
  void _drawText(Canvas canvas, String text, Offset position, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, position);
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) =>
      oldDelegate.controller != controller;
}
