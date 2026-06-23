// ============================================
// ФАЙЛ: lib/field/grid_field.dart
// ЧАСТЬ ПЛАНА: 2.8 — Undo/redo, панель инструментов
// ЧТО ДЕЛАЕТ: интерактивная сетка с состоянием, историей и клавишами
// ЗАВИСИТ ОТ: grid_controller.dart, grid_painter.dart, слои, state
// ============================================

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/math_model/math_point.dart';
import '../core/math_model/point_object.dart';
import '../state/field_state.dart';
import '../state/history_state.dart';
import '../state/tool_state.dart';
import 'grid_controller.dart';
import 'grid_painter.dart';
import 'grid_settings.dart';
import 'layers/annotations_layer.dart';
import 'layers/interaction_layer.dart';
import 'layers/objects_layer.dart';
import 'tool_panel.dart';

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

  // Ctrl+Z / Ctrl+Y — undo/redo
  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final isCtrl = HardwareKeyboard.instance.isControlPressed;
    if (!isCtrl) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      ref.read(historyProvider.notifier).undo();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.keyY) {
      ref.read(historyProvider.notifier).redo();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
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

  // Поставить точку через команду (undo/redo поддерживается)
  void _placePoint(Offset screenPos) {
    var fieldPos = _controller.screenToField(screenPos);

    if (_controller.settings.snapToGrid) {
      fieldPos = _controller.snapToGrid(fieldPos);
    }

    // Метка A, B, C... по числу уже существующих точек
    final existingPoints =
        ref.read(fieldProvider).objects.whereType<PointObject>().length;
    final label = existingPoints < 26
        ? String.fromCharCode('A'.codeUnitAt(0) + existingPoints)
        : 'P$existingPoints';

    final obj = PointObject(
      point: MathPoint(x: fieldPos.dx, y: fieldPos.dy, label: label),
    );

    // Через историю — чтобы Ctrl+Z мог отменить
    ref.read(historyProvider.notifier).execute(AddObjectCommand(obj));
  }

  @override
  Widget build(BuildContext context) {
    final fieldState = ref.watch(fieldProvider);

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

        // Focus — чтобы ловить Ctrl+Z / Ctrl+Y
        return Focus(
          autofocus: true,
          onKeyEvent: _onKeyEvent,
          child: Listener(
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

                  // Панель инструментов слева
                  const Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ToolPanel(),
                    ),
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
          ),
        );
      },
    );
  }
}
