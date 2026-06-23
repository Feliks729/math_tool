// ============================================
// ФАЙЛ: lib/core/math_model/math_object.dart
// ЧАСТЬ ПЛАНА: 1.2 — Базовые типы данных
// ЧТО ДЕЛАЕТ: общий базовый класс для всех объектов на поле
// ЗАВИСИТ ОТ: constants.dart
// ============================================

// Тип математического объекта на поле
enum MathObjectType {
  point,
  segment,
  angle,
  triangle,
  circle,
  polygon,
  vector,
  function,
  inequality,
  numberLine,
}

// Ограничивающий прямоугольник объекта на поле
typedef BoundingBox = ({double minX, double minY, double maxX, double maxY});

abstract class MathObject {
  /// Уникальный идентификатор — генерируется при создании
  final String id;

  final MathObjectType type;

  bool isVisible;
  bool isSelected;

  MathObject({
    required this.type,
    this.isVisible = true,
    this.isSelected = false,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Ограничивающий прямоугольник — нужен для хит-теста и отрисовки
  BoundingBox boundingBox();

  // Выделить объект
  void select() => isSelected = true;

  // Снять выделение
  void deselect() => isSelected = false;

  // Переключить видимость
  void toggleVisibility() => isVisible = !isVisible;

  @override
  String toString() =>
      'MathObject(id: $id, type: ${type.name}, visible: $isVisible, selected: $isSelected)';
}
