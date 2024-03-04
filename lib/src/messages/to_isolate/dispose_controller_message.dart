part of 'incoming_message.dart';

@immutable
final class _$Dispose$ControllerMessage extends IncomingIsolateMessage {
  const _$Dispose$ControllerMessage({
    required super.controllerKey,
    required this.onDispose,
  });
  final void Function(Object) onDispose;

  @override
  String toString() => 'DisposeControllerMessage(controller: $controllerKey)';
}
