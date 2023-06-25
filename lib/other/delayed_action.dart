import 'dart:async';
import 'dart:ui';

/// Выполнить действие по истечению таймера
///
/// Удобно, если нужно отработать нажатие на кнопку (или на ввод),
/// но нужно исключить множественное выполнение операции.
/// Выполняется только последняя операция, которая попадает на вход
class DelayedAction {
  factory DelayedAction() => _instance;

  DelayedAction._();

  static final DelayedAction _instance = DelayedAction._();

  static Timer? _timer;

  static void run(
    VoidCallback action, {
    Duration delay = const Duration(milliseconds: 200),
  }) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
