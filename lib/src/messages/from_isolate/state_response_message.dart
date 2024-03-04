import 'package:meta/meta.dart';

@immutable
class StateResponseMessage {

  const StateResponseMessage({required this.state, required this.controllerKey});

  factory StateResponseMessage.fromRecord((String, Object?) record) => StateResponseMessage(
        controllerKey: record.$1,
        state: record.$2,
      );
  final Object? state;
  final String controllerKey;

  @override
  String toString() => 'StateOutgoingMessage(controller: $controllerKey, state: $state)';
}
