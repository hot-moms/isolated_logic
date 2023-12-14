// ignore_for_file: library_private_types_in_public_api

import 'package:meta/meta.dart';

part 'dispose_controller_message.dart';
part 'event_controller_message.dart';
part 'register_controller_message.dart';

@immutable
sealed class IncomingIsolateMessage {
  final String controllerKey;

  const IncomingIsolateMessage({required this.controllerKey});

  @literal
  const factory IncomingIsolateMessage.dispose({
    required String controllerKey,
    required void Function(Object) onDispose,
  }) = _$Dispose$ControllerMessage;

  @literal
  const factory IncomingIsolateMessage.registerController({
    required String controllerKey,
    required Object Function(Object) createController,
    required Stream<Object?> Function(Object) stateStream,
  }) = _$Register$ControllerMessage;

  @literal
  const factory IncomingIsolateMessage.event({
    required String controllerKey,
    required void Function(Object) event,
  }) = _$Event$ControllerMessage;

  T when<T>({
    required T Function(String controllerKey, void Function(Object) event) events,
    required T Function(String controllerKey, void Function(Object) onDispose) dispose,
    required T Function(
      String controllerKey,
      Object Function(Object) createController,
      Stream<Object?> Function(Object) stateStream,
    ) registerController,
  }) =>
      switch (this) {
        _$Event$ControllerMessage(:final controllerKey, :final event) => events(controllerKey, event),
        _$Dispose$ControllerMessage(:final controllerKey, :final onDispose) => dispose(controllerKey, onDispose),
        _$Register$ControllerMessage(:final controllerKey, :final createController, :final stateStream) =>
          registerController(controllerKey, createController, stateStream),
      };
}
