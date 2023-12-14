import 'dart:developer';

import 'package:meta/meta.dart';

/// ControllerObserver Singleton class
abstract class IsolatedControllerObserver {
  @protected
  IsolatedControllerObserver();

  factory IsolatedControllerObserver.dartLog() => _TestControllerObserver();

  static Never _overrideError() =>
      throw UnimplementedError('This method should be overrided with your own logging package/solution');

  @mustBeOverridden
  void onCreate(String controllerKey) => _overrideError();

  @mustBeOverridden
  void onDispose(String controllerKey) => _overrideError();

  @mustBeOverridden
  void onStateChanged(String controllerKey, Object prevState, Object nextState) => _overrideError();

  @mustBeOverridden
  void onError(String? controllerKey, Object? error, StackTrace stackTrace) => _overrideError();

  @mustBeOverridden
  void onEvent(String controllerKey) => _overrideError();
}

class _TestControllerObserver extends IsolatedControllerObserver {
  @override
  void onCreate(String controllerKey) => log('[$controllerKey] Controller created', name: 'Logical Isolate');

  @override
  void onDispose(String controllerKey) => log('[$controllerKey] Controller disposed', name: 'Logical Isolate');

  @override
  void onError(String? controllerKey, Object? error, StackTrace stackTrace) =>
      log('[$controllerKey] Error: $error\nStacktrace:$stackTrace', name: 'Logical Isolate');

  @override
  void onStateChanged(String controllerKey, Object? prevState, Object? nextState) =>
      log('[$controllerKey] State updated: $nextState', name: 'Logical Isolate');

  @override
  void onEvent(String controllerKey) => log('[$controllerKey] got new event', name: 'Logical Isolate');
}
