// ============================================
// ФАЙЛ: lib/keyboard/math_keyboard.dart
// ЧАСТЬ ПЛАНА: 3.2 — Раскладки клавиатуры
// ЧТО ДЕЛАЕТ: виджет математической клавиатуры с базовой раскладкой
// ЗАВИСИТ ОТ: keyboard_controller.dart, math_display.dart
// ============================================

import 'package:flutter/material.dart';

import 'keyboard_controller.dart';
import 'math_display.dart';

// Описание одной кнопки клавиатуры
class _KeyDef {
  final String label;
  final VoidCallback onTap;
  final int flex;
  final bool isAccent; // выделенная кнопка (Готово, операции)

  const _KeyDef({
    required this.label,
    required this.onTap,
    this.flex = 1,
    this.isAccent = false,
  });
}

class MathKeyboard extends StatefulWidget {
  final KeyboardController controller;
  final VoidCallback? onConfirm;

  const MathKeyboard({
    super.key,
    required this.controller,
    this.onConfirm,
  });

  @override
  State<MathKeyboard> createState() => _MathKeyboardState();
}

class _MathKeyboardState extends State<MathKeyboard> {
  KeyboardController get _ctrl => widget.controller;

  // Строим все ряды кнопок на основе контроллера
  List<List<_KeyDef>> _buildRows() {
    return [
      // Ряд 1: цифры 7-9, деление, умножение
      [
        _KeyDef(label: '7',  onTap: () => _ctrl.appendSymbol('7', '7')),
        _KeyDef(label: '8',  onTap: () => _ctrl.appendSymbol('8', '8')),
        _KeyDef(label: '9',  onTap: () => _ctrl.appendSymbol('9', '9')),
        _KeyDef(label: '÷',  onTap: () => _ctrl.appendSymbol(r'\div', '/'), isAccent: true),
        _KeyDef(label: '×',  onTap: () => _ctrl.appendSymbol(r'\times', '*'), isAccent: true),
      ],
      // Ряд 2: цифры 4-6, сложение, вычитание
      [
        _KeyDef(label: '4',  onTap: () => _ctrl.appendSymbol('4', '4')),
        _KeyDef(label: '5',  onTap: () => _ctrl.appendSymbol('5', '5')),
        _KeyDef(label: '6',  onTap: () => _ctrl.appendSymbol('6', '6')),
        _KeyDef(label: '+',  onTap: () => _ctrl.appendSymbol('+', '+'), isAccent: true),
        _KeyDef(label: '-',  onTap: () => _ctrl.appendSymbol('-', '-'), isAccent: true),
      ],
      // Ряд 3: цифры 1-3, точка, равно
      [
        _KeyDef(label: '1',  onTap: () => _ctrl.appendSymbol('1', '1')),
        _KeyDef(label: '2',  onTap: () => _ctrl.appendSymbol('2', '2')),
        _KeyDef(label: '3',  onTap: () => _ctrl.appendSymbol('3', '3')),
        _KeyDef(label: '.',  onTap: () => _ctrl.appendSymbol('.', '.')),
        _KeyDef(label: '=',  onTap: () => _ctrl.appendSymbol('=', '=')),
      ],
      // Ряд 4: ноль, x, степень, корень, скобки
      [
        _KeyDef(label: '0',  onTap: () => _ctrl.appendSymbol('0', '0')),
        _KeyDef(label: 'x',  onTap: () => _ctrl.appendSymbol('x', 'x'), isAccent: true),
        _KeyDef(label: 'xⁿ', onTap: () => _ctrl.appendPower(), isAccent: true),
        _KeyDef(label: '√',  onTap: () => _ctrl.appendSqrt(), isAccent: true),
        _KeyDef(label: '( )', onTap: () {
          _ctrl.appendSymbol('(', '(');
          _ctrl.appendSymbol(')', ')');
        }),
      ],
      // Ряд 5: константы и функции
      [
        _KeyDef(label: 'π',   onTap: () => _ctrl.appendSymbol(r'\pi', 'pi'), isAccent: true),
        _KeyDef(label: 'sin', onTap: () => _ctrl.appendSymbol(r'\sin(', 'sin(')),
        _KeyDef(label: 'cos', onTap: () => _ctrl.appendSymbol(r'\cos(', 'cos(')),
        _KeyDef(label: 'tg',  onTap: () => _ctrl.appendSymbol(r'\tan(', 'tan(')),
        _KeyDef(label: '⌫',   onTap: () => _ctrl.backspace(), isAccent: true),
      ],
      // Ряд 6: служебные кнопки
      [
        _KeyDef(
          label: 'Очистить',
          onTap: () => _ctrl.clear(),
          flex: 2,
        ),
        _KeyDef(
          label: 'Готово',
          onTap: () => widget.onConfirm?.call(),
          flex: 3,
          isAccent: true,
        ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows();

    return Container(
      height: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Строка отображения введённого выражения
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: MathDisplay(controller: _ctrl),
          ),

          // Сетка кнопок — занимает остаток высоты
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                children: rows.map((row) => _buildRow(row)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Строит один ряд кнопок
  Widget _buildRow(List<_KeyDef> keys) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: keys.map((key) => _buildKey(key)).toList(),
      ),
    );
  }

  // Строит одну кнопку
  Widget _buildKey(_KeyDef key) {
    return Expanded(
      flex: key.flex,
      child: Padding(
        padding: const EdgeInsets.all(2.5),
        child: Material(
          color: key.isAccent
              ? const Color(0xFF2D2D44)
              : const Color(0xFF252535),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: key.onTap,
            borderRadius: BorderRadius.circular(8),
            splashColor: Colors.blue.withValues(alpha: 0.3),
            child: Center(
              child: Text(
                key.label,
                style: TextStyle(
                  color: key.isAccent
                      ? Colors.blue.shade300
                      : Colors.white.withValues(alpha: 0.9),
                  fontSize: key.label.length > 2 ? 13 : 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
