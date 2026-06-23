// ============================================
// ФАЙЛ: lib/field/grid_field.dart
// ЧАСТЬ ПЛАНА: 2.6 — Подключение состояния к полю
// ЧТО ДЕЛАЕТ: интерактивная сетка с состоянием через Riverpod
// ЗАВИСИТ ОТ: grid_controller.dart, grid_painter.dart, слои, state
// ============================================

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/math_model/math_point.dart';
import '../core/math_model/point_object.dart';
import '../state/field_state.dart';
import '../state/tool_state.dart';
import 'grid_controller.dart';
import 'grid_painter.dart';
import 'grid_settings.dart';
import 'layers/annotations_layer.dart';
import 'layers/interaction_layer.dart';
import 'layers/objects_layer.dart';

class GridField extends ConsumerStatefulWidget {
  final GridSettings? settings;

  const GridField({super.key, this.settings});

  @override
  ConsumerState<GridField> createState() => _GridFieldState();
}

class _GridFieldState extends ConsumerState<GridField> {
  late GridController _controller;

  double _scaleAtGestureStart = 1.0;
  bool _centered = false;

  @override
  void initState() {
    super.initState();
    _controller = GridController(
      settings: widget.settings ?? const GridSettings(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Колёсико мыши — зум
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (event.scrollDelta.dy < 0) {
        _controller.zoomIn();
      } else {
        _controller.zoomOut();
      }
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    _scaleAtGestureStart = _controller.scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale != 1.0) {
      final newScale =
          (_scaleAtGestureStart * details.scale).clamp(kZoomMin, kZoomMax);
      _controller.scale = newScale;
    }
    _controller.pan(details.focalPointDelta.dx, details.focalPointDelta.dy);
  }

  // Тап по полю — поведение зависит от активного инструмента
  void _onTapDown(TapDownDetails details) {
    final activeTool = ref.read(activeToolProvider);

    if (activeTool == ActiveTool.point) {
      _placePoint(details.localPosition);
    }
  }

  // Поставить точку в позиции тапа
  void _placePoint(Offset screenPos) {
    var fieldPos = _controller.screenToField(screenPos);

    // Привязка к узлу сетки если включена
    if (_controller.settings.snapToGrid) {
      fieldPos = _controller.snapToGrid(fieldPos);
    }

    // Следующая буква метки: A, B, C... по числу уже существующих точек
    final existingPoints = ref
        .read(fieldProvider)
        .objects
        .whereType<PointObject>()
        .length;
    final label = existingPoints < 26
        ? String.fromCharCode('A'.codeUnitAt(0) + existingPoints)
        : 'P$existingPoints';

    final obj = PointObject(
      point: MathPoint(x: fieldPos.dx, y: fieldPos.dy, label: label),
    );

    ref.read(fieldProvider.notifier).addObject(obj);
  }

  @override
  Widget build(BuildContext context) {
    final fieldState = ref.watch(fieldProvider);
    final activeTool = ref.watch(activeToolProvider);

    // Находим выделенный объект для InteractionLayer
    final selected = fieldState.selectedObjectId != null
        ? fieldState.objects
            .where((o) => o.id == fieldState.selectedObjectId)
            .firstOrNull
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        if (!_centered && size != Size.zero) {
          _centered = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _controller.centerOn(size);
          });
        }

        return Listener(
          onPointerSignal: _onPointerSignal,
          child: GestureDetector(
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onTapDown: _onTapDown,
            child: Stack(
              children: [
                // Слой 0 — сетка
                SizedBox.expand(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => CustomPaint(
                      painter: GridPainter(controller: _controller),
                    ),
                  ),
                ),

                // Слой 1 — объекты
                SizedBox.expand(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => CustomPaint(
                      painter: ObjectsLayer(
                        objects: fieldState.objects,
                        controller: _controller,
                      ),
                    ),
                  ),
                ),

                // Слой 2 — аннотации
                SizedBox.expand(
                  child: CustomPaint(
                    painter: AnnotationsLayer(
                      objects: fieldState.objects,
                      controller: _controller,
                    ),
                  ),
                ),

                // Слой 3 — интерактив
                SizedBox.expand(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => CustomPaint(
                      painter: InteractionLayer(
                        controller: _controller,
                        selectedObject: selected,
                      ),
                    ),
                  ),
                ),

                // Временная панель инструментов для тестирования
                Positioned(
                  top: 12,
                  left: 12,
                  child: _ToolBar(activeTool: activeTool),
                ),

                // Кнопка сброса вида
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.small(
                    onPressed: () => _controller.centerOn(size),
                    tooltip: 'Сбросить вид',
                    child: const Icon(Icons.home_outlined),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Временная панель инструментов — для тестирования постановки точек
class _ToolBar extends ConsumerWidget {
  final ActiveTool activeTool;

  const _ToolBar({required this.activeTool});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToolButton(
            icon: Icons.near_me,
            label: 'Select',
            active: activeTool == ActiveTool.select,
            onTap: () => ref.read(activeToolProvider.notifier).state =
                ActiveTool.select,
          ),
          _ToolButton(
            icon: Icons.circle,
            label: 'Point',
            active: activeTool == ActiveTool.point,
            onTap: () => ref.read(activeToolProvider.notifier).state =
                ActiveTool.point,
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? kColorPoint : Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: active ? kColorPoint : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
