// ============================================
// ФАЙЛ: lib/core/math_model/math_inequality.dart
// ЧАСТЬ ПЛАНА: 1.4 — Алгебраические объекты
// ЧТО ДЕЛАЕТ: неравенство для числовой прямой и областей
// ЗАВИСИТ ОТ: math_expression.dart, constants.dart
// ============================================

import '../constants.dart';
import 'math_expression.dart';

// Знак неравенства
enum InequalitySign {
  less,
  lessOrEqual,
  greater,
  greaterOrEqual;

  String toSymbol() => switch (this) {
        InequalitySign.less => '<',
        InequalitySign.lessOrEqual => '≤',
        InequalitySign.greater => '>',
        InequalitySign.greaterOrEqual => '≥',
      };

  // Строгое неравенство — концы интервала не включаются
  bool get isStrict =>
      this == InequalitySign.less || this == InequalitySign.greater;
}

// Интервал решения неравенства
typedef SolutionInterval = ({
  double start,
  double end,
  bool startIncluded,
  bool endIncluded
});

class MathInequality {
  final MathExpression left;
  final MathExpression right;
  final InequalitySign sign;

  const MathInequality({
    required this.left,
    required this.right,
    required this.sign,
  });

  // Проверяет выполняется ли неравенство при данном x
  bool isSatisfiedAt(double x) {
    final l = left.evaluate(x);
    final r = right.evaluate(x);
    if (l == null || r == null) return false;

    return switch (sign) {
      InequalitySign.less => l < r - kEpsilon,
      InequalitySign.lessOrEqual => l <= r + kEpsilon,
      InequalitySign.greater => l > r + kEpsilon,
      InequalitySign.greaterOrEqual => l >= r - kEpsilon,
    };
  }

  // Список интервалов решения в диапазоне [-10, 10]
  // Перебираем точки с шагом kPlotStep и группируем где неравенство выполняется
  List<SolutionInterval> solutionIntervals() {
    const xMin = -10.0;
    const xMax = 10.0;

    final intervals = <SolutionInterval>[];
    bool inInterval = false;
    double intervalStart = xMin;

    var x = xMin;
    while (x <= xMax + kPlotStep / 2) {
      final satisfied = isSatisfiedAt(x);

      if (satisfied && !inInterval) {
        // Начало нового интервала
        inInterval = true;
        intervalStart = x;
      } else if (!satisfied && inInterval) {
        // Конец интервала — предыдущий шаг был последним
        final intervalEnd = x - kPlotStep;
        intervals.add((
          start: intervalStart,
          end: intervalEnd,
          startIncluded: !sign.isStrict,
          endIncluded: !sign.isStrict,
        ));
        inInterval = false;
      }

      x += kPlotStep;
    }

    // Закрываем интервал если он дошёл до конца диапазона
    if (inInterval) {
      intervals.add((
        start: intervalStart,
        end: xMax,
        startIncluded: !sign.isStrict,
        endIncluded: !sign.isStrict,
      ));
    }

    return intervals;
  }

  @override
  String toString() =>
      '${left.expression} ${sign.toSymbol()} ${right.expression}';
}
