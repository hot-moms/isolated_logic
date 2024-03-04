part of 'incoming_message.dart';

@immutable
final class _$Event$ControllerMessage extends IncomingIsolateMessage {
  const _$Event$ControllerMessage({
    required super.controllerKey,
    required this.event,
  });
  final void Function(Object) event;

  @override
  String toString() => 'EventControllerMessage(controller: $controllerKey, event: $event)';
}
