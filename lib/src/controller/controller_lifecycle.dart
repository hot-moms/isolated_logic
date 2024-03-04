import 'package:meta/meta.dart';

typedef DisposeHandler<ControllerType extends Object> = void Function(ControllerType controller);
typedef StateStream<ControllerType extends Object> = Stream<Object?> Function(ControllerType controller);

@immutable

/// Descriptor that describes controller lifecycle, handling incoming events and state emitting
class ControllerLifecycleHandler<ControllerType extends Object> {

  const ControllerLifecycleHandler({
    required this.stateStream,
    required this.dispose,
  });
  /// Way to get stream of states from controller
  final StateStream<ControllerType> stateStream;

  /// Descriptor of state disposer
  final DisposeHandler<ControllerType> dispose;
}
