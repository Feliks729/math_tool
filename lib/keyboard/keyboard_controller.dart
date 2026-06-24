// ============================================
// ФАЙЛ: lib/keyboard/keyboard_controller.dart
// ЧАСТЬ ПЛАНА: 3.1 — Архитектура клавиатуры
// ЧТО ДЕЛАЕТ: контроллер ввода — хранит выражение в двух представлениях
// ЗАВИСИТ ОТ: math_expression.dart
// ============================================

import 'package:flutter/material.dart';

import '../core/math_model/math_expression.dart';

class KeyboardController extends ChangeNotifier {
  // Храним историю токенов — каждый appendXxx добавляет одну запись
  // Это позволяет backspace корректно удалять блоки целиком
  final List<String> _latexParts = [];
  final List<String> _exprParts = [];

  // Текущее LaTeX-представление
  String get latex => _latexParts.join();

  // Текущая вычислимая строка
  String get expression => _exprParts.join();

  // Добавить одиночный символ (буква, цифра, оператор)
  void appendSymbol(String latexSym, String exprSym) {
    _latexParts.add(latexSym);
    _exprParts.add(exprSym);
    notifyListeners();
  }

  // Добавить дробь — \frac{■}{■} / (■)/(■)
  void appendFraction() {
    _latexParts.add(r'\frac{■}{■}');
    _exprParts.add('(■)/(■)');
    notifyListeners();
  }

  // Обернуть последний токен в корень: 5 → \sqrt{5}
  // Если токенов нет — добавляет пустой корень
  void appendSqrt() {
    if (_latexParts.isEmpty) {
      _latexParts.add(r'\sqrt{}');
      _exprParts.add('sqrt()');
    } else {
      final lastLatex = _latexParts.removeLast();
      final lastExpr = _exprParts.removeLast();
      _latexParts.add('\\sqrt{$lastLatex}');
      _exprParts.add('sqrt($lastExpr)');
    }
    notifyListeners();
  }

  // Добавить степень: берёт последний токен целиком и приписывает к нему ^
  // Пример: \sqrt{5} → \sqrt{5}^  затем пользователь вводит показатель: \sqrt{5}^2
  // Единый токен гарантирует что backspace убирает основание вместе с ^
  void appendPower() {
    if (_latexParts.isEmpty) {
      _latexParts.add('^');
      _exprParts.add('^');
    } else {
      _latexParts[_latexParts.length - 1] += '^';
      _exprParts[_exprParts.length - 1] += '^';
    }
    notifyListeners();
  }

  // Удалить последний добавленный блок целиком
  void backspace() {
    if (_latexParts.isEmpty) return;
    _latexParts.removeLast();
    _exprParts.removeLast();
    notifyListeners();
  }

  // Очистить всё выражение
  void clear() {
    _latexParts.clear();
    _exprParts.clear();
    notifyListeners();
  }

  // Собрать MathExpression из текущего состояния
  MathExpression toMathExpression() {
    return MathExpression(latex: latex, expression: expression);
  }
}
