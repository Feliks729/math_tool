// ============================================
// ФАЙЛ: lib/keyboard/math_display.dart
// ЧАСТЬ ПЛАНА: 3.1 — Архитектура клавиатуры
// ЧТО ДЕЛАЕТ: отображает введённое выражение в виде LaTeX
// ЗАВИСИТ ОТ: keyboard_controller.dart, flutter_math_fork
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'keyboard_controller.dart';

class MathDisplay extends ConsumerWidget {
  final KeyboardController controller;

  const MathDisplay({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final latex = controller.latex;

        return Container(
          constraints: const BoxConstraints(minHeight: 60),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: latex.isEmpty
              ? Text(
                  'Введите выражение...',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 18,
                  ),
                )
              : Math.tex(
                  // flutter_math_fork не поддерживает ■ — заменяем на \square
                  latex.replaceAll('■', r'\square'),
                  textStyle: const TextStyle(fontSize: 24),
                  onErrorFallback: (err) => Text(
                    latex,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
        );
      },
    );
  }
}
