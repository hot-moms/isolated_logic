import 'package:meta/meta.dart';

@immutable
class StateResponseMessage {
  final Object? state;
  final String controllerKey;

  factory StateResponseMessage.fromRecord((String, Object?) record) => StateResponseMessage(
        controllerKey: record.$1,
        state: record.$2,
      );

  const StateResponseMessage({required this.state, required this.controllerKey});

  @override
  String toString() => 'StateOutgoingMessage(controller: $controllerKey, state: $state)';
}
