import 'dart:async';
import 'dart:isolate';

import 'package:isolated_logic/isolated_logic.dart';
import 'package:isolated_logic/src/messages/from_isolate/state_response_message.dart';
import 'package:isolated_logic/src/messages/to_isolate/incoming_message.dart';
import 'package:isolated_logic/src/utils/extensions.dart';
import 'package:stream_transform/stream_transform.dart';

final class IsolatedWorker<DependenciesInterface extends Object> {
  IsolatedWorker({
    required SendPort port,
    required FutureOr<DependenciesInterface> dependencies,
    IsolatedControllerObserver? observer,
  })  : _port = port,
        _observer = observer,
        _dependencies = dependencies;

  final SendPort _port;
  final FutureOr<DependenciesInterface> _dependencies;
  final IsolatedControllerObserver? _observer;

  final Map<String, Object> _controllersStorage = {};

  /// Outgoung states stream
  late final StreamController<(String, Object?)> _statesController = StreamController.broadcast()
    ..stream.listen(_handleOutgoingState);

  void _handleOutgoingState((String controllerKey, Object? state) packedState) =>
      _port.send(StateResponseMessage.fromRecord(packedState));

  void _handleMessage(IncomingIsolateMessage message) => message.when(
        dispose: _disposeControllerMessage,
        registerController: _registerControllerMessage,
        events: _eventControllerMessage,
      );

  void _disposeControllerMessage(String controllerKey, void Function(Object) dispose) {
    _controllersStorage[controllerKey]?.pipe(dispose);
    _controllersStorage.remove(controllerKey);

    _observer?.onDispose(controllerKey);
  }

  void _eventControllerMessage(String controllerKey, void Function(Object) event) {
    _controllersStorage[controllerKey]?.pipeGuarded(
      event,
      onError: (e, s) => _observer?.onError(controllerKey, e, s),
    );

    _observer?.onEvent(controllerKey);
  }

  void _registerControllerMessage(
      String controllerKey, Object Function(Object) createController, Stream<Object?> Function(Object) statesStream) {
    if (_controllersStorage.containsKey(controllerKey)) return;

    final controller = createController(_dependencies);
    _controllersStorage[controllerKey] = controller;

    statesStream(controller).map((state) => (controllerKey, state)).listen(_statesController.add);
    _observer?.onCreate(controllerKey);
  }

  void call() {
    final receivePort = ReceivePort();
    final _ = receivePort.asBroadcastStream().whereType<IncomingIsolateMessage>().listen(_handleMessage);

    _port.send(receivePort.sendPort);
  }
}
