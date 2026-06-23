// ============================================
// ФАЙЛ: lib/field/grid_settings.dart
// ЧАСТЬ ПЛАНА: 2.1 — GridField
// ЧТО ДЕЛАЕТ: все настройки сетки в одном месте
// ЗАВИСИТ ОТ: constants.dart
// ============================================

import 'package:flutter/material.dart';

import '../core/constants.dart';

class GridSettings {
  /// Размер одной клетки в пикселях
  final double cellSize;

  /// Показывать оси координат
  final bool showAxes;

  /// Показывать подписи делений на осях
  final bool showLabels;

  final Color backgroundColor;
  final Color gridColor;
  final Color axisColor;

  /// Привязывать точки к узлам сетки
  final bool snapToGrid;

  const GridSettings({
    this.cellSize = kCellSize,
    this.showAxes = true,
    this.showLabels = true,
    this.backgroundColor = kColorBackground,
    this.gridColor = kColorGrid,
    this.axisColor = kColorAxis,
    this.snapToGrid = true,
  });

  GridSettings copyWith({
    double? cellSize,
    bool? showAxes,
    bool? showLabels,
    Color? backgroundColor,
    Color? gridColor,
    Color? axisColor,
    bool? snapToGrid,
  }) {
    return GridSettings(
      cellSize: cellSize ?? this.cellSize,
      showAxes: showAxes ?? this.showAxes,
      showLabels: showLabels ?? this.showLabels,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gridColor: gridColor ?? this.gridColor,
      axisColor: axisColor ?? this.axisColor,
      snapToGrid: snapToGrid ?? this.snapToGrid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! GridSettings) return false;
    return cellSize == other.cellSize &&
        showAxes == other.showAxes &&
        showLabels == other.showLabels &&
        backgroundColor == other.backgroundColor &&
        gridColor == other.gridColor &&
        axisColor == other.axisColor &&
        snapToGrid == other.snapToGrid;
  }

  @override
  int get hashCode => Object.hash(
        cellSize,
        showAxes,
        showLabels,
        backgroundColor,
        gridColor,
        axisColor,
        snapToGrid,
      );
}
