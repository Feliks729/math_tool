// ============================================
// ФАЙЛ: lib/state/history_state.dart
// ЧАСТЬ ПЛАНА: 2.8 — Undo/redo по паттерну Command
// ЧТО ДЕЛАЕТ: стек команд, отмена и повтор действий на поле
// ЗАВИСИТ ОТ: field_state.dart, math_object.dart, riverpod
// ============================================

import 'package:riverpod/riverpod.dart';

import '../core/math_model/math_object.dart';
import 'field_state.dart';

// ─── Паттерн Command ─────────────────────────────────────────────────────────

abstract class FieldCommand {
  // Ref передаётся из нотифаера — команда не хранит его сама
  void execute(Ref ref);
  void undo(Ref ref);
}

// Команда добавления объекта на поле
class AddObjectCommand implements FieldCommand {
  final MathObject object;

  AddObjectCommand(this.object);

  @override
  void execute(Ref ref) {
    ref.read(fieldProvider.notifier).addObject(object);
  }

  @override
  void undo(Ref ref) {
    ref.read(fieldProvider.notifier).removeObject(object.id);
  }
}

// ─── Состояние истории ───────────────────────────────────────────────────────

class HistoryState {
  final bool canUndo;
  final bool canRedo;

  const HistoryState({required this.canUndo, required this.canRedo});
}

// ─── Нотифаер ────────────────────────────────────────────────────────────────

class HistoryNotifier extends Notifier<HistoryState> {
  final List<FieldCommand> _undoStack = [];
  final List<FieldCommand> _redoStack = [];

  @override
  HistoryState build() =>
      const HistoryState(canUndo: false, canRedo: false);

  // Выполнить команду и положить в стек undo
  void execute(FieldCommand cmd) {
    cmd.execute(ref);
    _undoStack.add(cmd);
    // После нового действия redo-стек сбрасывается
    _redoStack.clear();
    _updateState();
  }

  // Отменить последнее действие
  void undo() {
    if (_undoStack.isEmpty) return;
    final cmd = _undoStack.removeLast();
    cmd.undo(ref);
    _redoStack.add(cmd);
    _updateState();
  }

  // Повторить отменённое действие
  void redo() {
    if (_redoStack.isEmpty) return;
    final cmd = _redoStack.removeLast();
    cmd.execute(ref);
    _undoStack.add(cmd);
    _updateState();
  }

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void _updateState() {
    state = HistoryState(
      canUndo: _undoStack.isNotEmpty,
      canRedo: _redoStack.isNotEmpty,
    );
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, HistoryState>(
  HistoryNotifier.new,
);
