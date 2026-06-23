// ============================================
// ФАЙЛ: lib/core/math_model/math_expression.dart
// ЧАСТЬ ПЛАНА: 1.2 — Базовые типы данных
// ЧТО ДЕЛАЕТ: математическое выражение в двух форматах — LaTeX и вычислимая строка
// ЗАВИСИТ ОТ: constants.dart, пакет math_expressions
// ============================================

import 'dart:math';

import 'package:math_expressions/math_expressions.dart';

import '../constants.dart';

class MathExpression {
  /// Представление для отображения — LaTeX (например \frac{x}{2})
  final String latex;

  /// Представление для вычислений (например x/2)
  final String expression;

  const MathExpression({
    required this.latex,
    required this.expression,
  });

  /// Создать из строки — оба поля будут одинаковы
  static MathExpression fromString(String input) {
    return MathExpression(latex: input, expression: input);
  }

  /// Вычислить значение выражения при данном x
  /// Возвращает null если выражение не вычисляется
  double? evaluate(double x) {
    try {
      final parser = GrammarParser();
      final exp = parser.parse(expression);
      final context = ContextModel()..bindVariable(Variable('x'), Number(x));
      final result = exp.evaluate(EvaluationType.REAL, context) as double;
      if (result.isNaN || result.isInfinite) return null;
      return result;
    } catch (_) {
      return null;
    }
  }

  /// Проверяет парсится ли выражение без ошибок
  bool isValid() {
    try {
      GrammarParser().parse(expression);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Числовая проверка эквивалентности — подставляем контрольные значения x
  /// и сравниваем результаты с точностью kEpsilon
  bool isEquivalentTo(MathExpression other) {
    final checkPoints = [1.0, 2.0, 3.0, -1.0, 0.5, pi];

    for (final x in checkPoints) {
      final a = evaluate(x);
      final b = other.evaluate(x);

      // Оба вернули null — считаем совпадением в этой точке
      if (a == null && b == null) continue;

      // Один вычислился, другой нет — не эквивалентны
      if (a == null || b == null) return false;

      if ((a - b).abs() > kEpsilon) return false;
    }

    return true;
  }

  @override
  bool operator ==(Object other) {
    if (other is! MathExpression) return false;
    return expression == other.expression && latex == other.latex;
  }

  @override
  int get hashCode => Object.hash(latex, expression);

  @override
  String toString() => 'MathExpression(expression: "$expression", latex: "$latex")';
}
