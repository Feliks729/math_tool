// ============================================
// ФАЙЛ: lib/state/field_state.dart
// ЧАСТЬ ПЛАНА: 2.5 — Глобальное состояние поля
// ЧТО ДЕЛАЕТ: хранит список объектов на поле и выделение
// ЗАВИСИТ ОТ: math_object.dart, riverpod
// ============================================

import 'package:riverpod/riverpod.dart';

import '../core/math_model/math_object.dart';

// Состояние поля — неизменяемый снимок
class FieldState {
  final List<MathObject> objects;

  /// id выделенного объекта, null если ничего не выделено
  final String? selectedObjectId;

  const FieldState({
    required this.objects,
    this.selectedObjectId,
  });

  FieldState copyWith({
    List<MathObject>? objects,
    String? selectedObjectId,
    bool clearSelection = false,
  }) {
    return FieldState(
      objects: objects ?? this.objects,
      selectedObjectId:
          clearSelection ? null : (selectedObjectId ?? this.selectedObjectId),
    );
  }
}

// Нотифаер — вся логика изменения состояния поля
class FieldNotifier extends Notifier<FieldState> {
  @override
  FieldState build() => const FieldState(objects: [], selectedObjectId: null);

  // Добавить объект на поле
  void addObject(MathObject obj) {
    state = state.copyWith(objects: [...state.objects, obj]);
  }

  // Удалить объект по id
  void removeObject(String id) {
    final updated = state.objects.where((o) => o.id != id).toList();
    final wasSelected = state.selectedObjectId == id;
    state = state.copyWith(
      objects: updated,
      clearSelection: wasSelected,
    );
  }

  // Выделить объект (null — снять выделение)
  void selectObject(String? id) {
    state = state.copyWith(
      selectedObjectId: id,
      clearSelection: id == null,
    );
  }

  // Очистить всё поле
  void clearAll() {
    state = const FieldState(objects: [], selectedObjectId: null);
  }
}

final fieldProvider = NotifierProvider<FieldNotifier, FieldState>(
  FieldNotifier.new,
);
