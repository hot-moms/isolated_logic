import 'dart:async';
import 'dart:isolate';

import 'package:isolated_logic/src/isolate/isolate_worker.dart';
import 'package:isolated_logic/src/messages/from_isolate/state_response_message.dart';
import 'package:isolated_logic/src/messages/to_isolate/incoming_message.dart';
import 'package:isolated_logic/src/observer/isolate_observer.dart';
import 'package:isolated_logic/src/utils/extensions.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart' as transform;

LogicalHandler get logicalHandler => LogicalHandler();

/// LogicalHandler Singleton class
@protected
final class LogicalHandler {
  factory LogicalHandler() => _internalSingleton;
  LogicalHandler._internal();
  static final LogicalHandler _internalSingleton = LogicalHandler._internal();

  /// [ControllerType] means base class for each controller that isolate handles
  /// Example: BlocBase
  Future<void> init<DependenciesInterface extends Object>({
    required FutureOr<DependenciesInterface> dependencies,
    IsolatedControllerObserver? observer,
    String debugName = 'logical_isolate',
  }) async {
    if (_logicalIsolate != null) return;

    final toMainIsolate = ReceivePort();
    final toMainIsolateStream = toMainIsolate.asBroadcastStream();

    final worker = IsolatedWorker<DependenciesInterface>(
      port: toMainIsolate.sendPort,
      dependencies: dependencies,
      observer: observer,
    );

    _logicalIsolate ??= await Isolate.spawn(
      (run) => run(),
      worker,
      debugName: debugName,
      errorsAreFatal: false,
    );
    _toLogicIsolate = await toMainIsolateStream.whereType<SendPort>().first;

    _statesStream = toMainIsolateStream.whereType<StateResponseMessage>().asBroadcastStream();
  }

  /// Isolate that handles all interaction
  Isolate? _logicalIsolate;

  late final SendPort _toLogicIsolate;
  late final Stream<StateResponseMessage> _statesStream;

  Stream<State?> listenController<State extends Object>(String controllerKey) => _statesStream
      .where((event) => event.controllerKey == controllerKey)
      .map((event) => event.state as State?)
      .asBroadcastStream();

  void registerController<DependenciesInterface extends Object>(
    String controllerKey, {
    required Object Function(DependenciesInterface dependencies) createController,
    required Stream<Object?> Function(Object) statesStream,
  }) {
    _toLogicIsolate.send(IncomingIsolateMessage.registerController(
        createController: createController.prepare, controllerKey: controllerKey, stateStream: statesStream,),);
  }

  void sendEvent(String controllerKey, {required void Function(Object) event}) =>
      _toLogicIsolate.send(IncomingIsolateMessage.event(event: event, controllerKey: controllerKey));

  void disposeController(
    String controllerKey,
    void Function(Object) dispose,
  ) =>
      _toLogicIsolate.send(IncomingIsolateMessage.dispose(controllerKey: controllerKey, onDispose: dispose));
}
