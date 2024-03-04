import 'package:isolated_logic/isolated_logic.dart';
import 'package:isolated_logic/src/controller/mixin/controller_key.dart';
import 'package:isolated_logic/src/controller/mixin/controller_state_mixin.dart';
import 'package:isolated_logic/src/utils/extensions.dart';
import 'package:meta/meta.dart';

abstract class IsolatedController<MainController extends Object, DependenciesInterface extends Object,
        EventBaseClass extends Object, StateClass extends Object>
    with IsolatedControllerKey<MainController>, IsolatedControllerState<MainController, StateClass> {
  IsolatedController({
    required MainController Function(DependenciesInterface dependencies) createController,
  }) {
    logicalHandler.registerController(
      $controllerKey,
      createController: createController,
      statesStream: controllerLifecycle.stateStream.prepare,
    );
  }
  @mustBeOverridden
  ControllerLifecycleHandler<MainController> get controllerLifecycle;

  @nonVirtual
  void isolateHandle(
    void Function(MainController controller) event,
  ) =>
      logicalHandler.sendEvent(
        $controllerKey,
        event: event.prepare,
      );

  @mustCallSuper
  void dispose() => logicalHandler.disposeController(
        $controllerKey,
        controllerLifecycle.dispose.prepare,
      );
}
