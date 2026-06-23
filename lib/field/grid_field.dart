// ============================================
// ФАЙЛ: lib/field/grid_field.dart
// ЧАСТЬ ПЛАНА: 2.1 — GridField — главный виджет
// ЧТО ДЕЛАЕТ: интерактивная сетка с зумом и панорамой
// ЗАВИСИТ ОТ: grid_controller.dart, grid_painter.dart, grid_settings.dart
// ============================================

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';

import 'grid_controller.dart';
import 'grid_painter.dart';
import 'grid_settings.dart';

class GridField extends StatefulWidget {
  final GridSettings? settings;

  const GridField({super.key, this.settings});

  @override
  State<GridField> createState() => _GridFieldState();
}

class _GridFieldState extends State<GridField> {
  late GridController _controller;

  // Масштаб в начале жеста — нужен чтобы зум был относительным
  double _scaleAtGestureStart = 1.0;

  // Флаг — центрировали ли уже при первом layout
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

  // Колёсико мыши — зум на desktop и в браузере
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
      final newScale = (_scaleAtGestureStart * details.scale).clamp(kZoomMin, kZoomMax);
      _controller.scale = newScale;
    }
    _controller.pan(details.focalPointDelta.dx, details.focalPointDelta.dy);
  }

  void _onTapDown(TapDownDetails details) {
    final fieldPoint = _controller.screenToField(details.localPosition);
    debugPrint(
      'Тап: (${fieldPoint.dx.toStringAsFixed(2)}, ${fieldPoint.dy.toStringAsFixed(2)})',
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        // Центрируем один раз при первом построении
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
                SizedBox.expand(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => CustomPaint(
                      painter: GridPainter(controller: _controller),
                    ),
                  ),
                ),

                // Кнопка сброса — центрирует с текущим размером экрана
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
