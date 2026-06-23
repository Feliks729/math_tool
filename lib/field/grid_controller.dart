// ============================================
// ФАЙЛ: lib/field/grid_controller.dart
// ЧАСТЬ ПЛАНА: 2.1 — GridField
// ЧТО ДЕЛАЕТ: управляет масштабом и позицией камеры на поле
// ЗАВИСИТ ОТ: constants.dart, grid_settings.dart
// ============================================

import 'package:flutter/material.dart';

import '../core/constants.dart';
import 'grid_settings.dart';

class GridController extends ChangeNotifier {
  /// Текущий масштаб
  double scale;

  /// Смещение камеры по X и Y в пикселях экрана
  double offsetX;
  double offsetY;

  GridSettings settings;

  // Запоминаем последний известный размер экрана для reset()
  Size _lastScreenSize = Size.zero;

  GridController({
    this.scale = kZoomDefault,
    this.offsetX = 0,
    this.offsetY = 0,
    GridSettings? settings,
  }) : settings = settings ?? const GridSettings();

  // Увеличить масштаб на 20%, не выходя за kZoomMax
  void zoomIn() {
    scale = (scale * 1.2).clamp(kZoomMin, kZoomMax);
    notifyListeners();
  }

  // Уменьшить масштаб на 20%, не выходя за kZoomMin
  void zoomOut() {
    scale = (scale / 1.2).clamp(kZoomMin, kZoomMax);
    notifyListeners();
  }

  // Сдвинуть камеру на (dx, dy) пикселей
  void pan(double dx, double dy) {
    offsetX += dx;
    offsetY += dy;
    notifyListeners();
  }

  // Установить offset так чтобы точка (0,0) оказалась в центре экрана
  void centerOn(Size screenSize) {
    _lastScreenSize = screenSize;
    scale = kZoomDefault;
    offsetX = screenSize.width / 2;
    offsetY = screenSize.height / 2;
    notifyListeners();
  }

  // Вернуть масштаб и позицию к начальным значениям с центрированием
  void reset() {
    centerOn(_lastScreenSize);
  }

  // Перевести координаты экрана в координаты поля
  // Учитывает текущий масштаб и смещение камеры
  Offset screenToField(Offset screen) {
    final cellPx = settings.cellSize * scale;
    return Offset(
      (screen.dx - offsetX) / cellPx,
      -(screen.dy - offsetY) / cellPx,
    );
  }

  // Перевести координаты поля в координаты экрана
  Offset fieldToScreen(Offset field) {
    final cellPx = settings.cellSize * scale;
    return Offset(
      field.dx * cellPx + offsetX,
      -field.dy * cellPx + offsetY,
    );
  }

  // Привязать точку поля к ближайшему узлу сетки
  Offset snapToGrid(Offset fieldPoint) {
    return Offset(
      (fieldPoint.dx).roundToDouble(),
      (fieldPoint.dy).roundToDouble(),
    );
  }
}
