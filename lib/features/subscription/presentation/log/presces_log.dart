import 'package:flutter/foundation.dart';

/// Small console logger for the in-app purchase flow.
/// Only prints in debug/profile mode (nothing is printed in release builds).
///
/// Tip: in VS Code / Android Studio console, filter by "IAP" to see only
/// the purchase flow logs.
class PLog {
  static const String _tag = 'IAP';
  static const String _line =
      '────────────────────────────────────────────────────────────';

  static String _time() {
    final n = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    String three(int v) => v.toString().padLeft(3, '0');
    return '${two(n.hour)}:${two(n.minute)}:${two(n.second)}.${three(n.millisecond)}';
  }

  static void _out(String icon, String level, String msg) {
    if (kReleaseMode) return;
    debugPrint('[$_tag][${_time()}] $icon $level │ $msg');
  }

  /// Big visible header for a new stage of the flow.
  static void section(String title) {
    if (kReleaseMode) return;
    debugPrint('');
    debugPrint('[$_tag] ┌$_line');
    debugPrint('[$_tag] │ ${_time()}  $title');
    debugPrint('[$_tag] └$_line');
  }

  static void info(String msg) => _out('ℹ️ ', 'INFO ', msg);
  static void step(String msg) => _out('👉', 'STEP ', msg);
  static void success(String msg) => _out('✅', 'OK   ', msg);
  static void warn(String msg) => _out('⚠️ ', 'WARN ', msg);

  static void error(String msg, [Object? error, StackTrace? stack]) {
    _out('❌', 'ERROR', msg);
    if (error != null) _out('❌', 'ERROR', 'cause: $error');
    if (stack != null && !kReleaseMode) {
      debugPrint('[$_tag] stack: ${stack.toString().split('\n').take(6).join('\n[$_tag]        ')}');
    }
  }

  /// Prints a small key/value table.
  static void kv(String title, Map<String, Object?> data) {
    if (kReleaseMode) return;
    debugPrint('[$_tag] ┌─ $title');
    data.forEach((k, v) {
      debugPrint('[$_tag] │ ${k.padRight(18)}: $v');
    });
    debugPrint('[$_tag] └─────────────────────');
  }

  /// Hides most of a secret (token, purchase token...) so it is safe to
  /// copy/paste logs to other people.
  static String mask(String? value, {int show = 6}) {
    if (value == null || value.isEmpty) return '<empty>';
    if (value.length <= show * 2) return '***(${value.length})';
    return '${value.substring(0, show)}…${value.substring(value.length - show)} (len ${value.length})';
  }
}