part of 'incoming_message.dart';

@immutable
final class _$Dispose$ControllerMessage extends IncomingIsolateMessage {
  final void Function(Object) onDispose;
  const _$Dispose$ControllerMessage({
    required super.controllerKey,
    required this.onDispose,
  });

  @override
  String toString() => 'DisposeControllerMessage(controller: $controllerKey)';
}
