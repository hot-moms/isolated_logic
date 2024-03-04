part of 'incoming_message.dart';

@immutable
final class _$Register$ControllerMessage extends IncomingIsolateMessage {

  const _$Register$ControllerMessage({
    required super.controllerKey,
    required this.createController,
    required this.stateStream,
  });
  final Object Function(Object) createController;
  final Stream<Object?> Function(Object) stateStream;

  @override
  String toString() => 'RegisterControllerMessage(controller: $controllerKey)';
}
