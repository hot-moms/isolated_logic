import 'package:isolated_logic/isolated_logic.dart';
import 'package:isolated_logic/src/controller/mixin/controller_key.dart';
import 'package:meta/meta.dart';

mixin IsolatedControllerState<MainController extends Object, StateClass extends Object>
    implements IsolatedControllerKey<MainController> {
  @nonVirtual
  @protected
  Stream<StateClass?>? _stream;

  @nonVirtual
  Stream<StateClass?> get stream => _stream ??= logicalHandler.listenController($controllerKey);
}
