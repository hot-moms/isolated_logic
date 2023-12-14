part of 'incoming_message.dart';

@immutable
final class _$Event$ControllerMessage extends IncomingIsolateMessage {
  final void Function(Object) event;
  const _$Event$ControllerMessage({
    required super.controllerKey,
    required this.event,
  });

  @override
  String toString() => 'EventControllerMessage(controller: $controllerKey, event: $event)';
}
