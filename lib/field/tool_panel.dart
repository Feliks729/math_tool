// ============================================
// ФАЙЛ: lib/field/tool_panel.dart
// ЧАСТЬ ПЛАНА: 2.7 — Панель инструментов
// ЧТО ДЕЛАЕТ: вертикальная панель выбора активного инструмента
// ЗАВИСИТ ОТ: tool_state.dart, constants.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/tool_state.dart';

class ToolPanel extends ConsumerWidget {
  const ToolPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTool = ref.watch(activeToolProvider);

    return Container(
      width: 64,
      margin: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6),
          _ToolButton(
            tool: ActiveTool.select,
            icon: Icons.near_me,
            label: 'Выбор',
            activeTool: activeTool,
            onTap: () => ref.read(activeToolProvider.notifier).state =
                ActiveTool.select,
          ),
          _ToolButton(
            tool: ActiveTool.point,
            icon: Icons.circle,
            label: 'Точка',
            activeTool: activeTool,
            onTap: () => ref.read(activeToolProvider.notifier).state =
                ActiveTool.point,
          ),
          _ToolButton(
            tool: ActiveTool.segment,
            icon: Icons.horizontal_rule,
            label: 'Отрезок',
            activeTool: activeTool,
            onTap: () => ref.read(activeToolProvider.notifier).state =
                ActiveTool.segment,
          ),
          _ToolButton(
            tool: ActiveTool.triangle,
            icon: Icons.change_history,
            label: 'Треугол.',
            activeTool: activeTool,
            onTap: () => ref.read(activeToolProvider.notifier).state =
                ActiveTool.triangle,
          ),
          _ToolButton(
            tool: ActiveTool.circle,
            icon: Icons.circle_outlined,
            label: 'Окр-сть',
            activeTool: activeTool,
            onTap: () => ref.read(activeToolProvider.notifier).state =
                ActiveTool.circle,
          ),
          _ToolButton(
            tool: ActiveTool.function,
            icon: Icons.show_chart,
            label: 'f(x)',
            activeTool: activeTool,
            onTap: () => ref.read(activeToolProvider.notifier).state =
                ActiveTool.function,
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final ActiveTool tool;
  final IconData icon;
  final String label;
  final ActiveTool activeTool;
  final VoidCallback onTap;

  const _ToolButton({
    required this.tool,
    required this.icon,
    required this.label,
    required this.activeTool,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = activeTool == tool;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.blue.withValues(alpha: 0.35)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: isActive ? 22 : 20,
                color: isActive ? Colors.blue.shade300 : Colors.white70,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: isActive ? Colors.blue.shade200 : Colors.white54,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
