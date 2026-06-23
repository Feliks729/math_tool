// ============================================
// ФАЙЛ: lib/core/math_model/math_figure.dart
// ЧАСТЬ ПЛАНА: 1.3 — Геометрические объекты
// ЧТО ДЕЛАЕТ: базовый абстрактный класс для всех геометрических фигур
// ЗАВИСИТ ОТ: math_point.dart, constants.dart
// ============================================

import 'package:flutter/material.dart';

import '../constants.dart';
import 'math_point.dart';

abstract class MathFigure {
  final bool isSelected;
  final Color color;

  const MathFigure({
    this.isSelected = false,
    this.color = kColorPoint,
  });

  // Площадь фигуры
  double area();

  // Периметр фигуры
  double perimeter();

  // Содержит ли фигура точку p (внутри или на границе)
  bool contains(MathPoint p);

  @override
  String toString();
}
