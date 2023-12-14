import 'package:isolated_logic/src/utils/extensions.dart';
import 'package:meta/meta.dart';

mixin IsolatedControllerKey<MainController> {
  String? _controllerKey;

  @nonVirtual
  String get $controllerKey => _controllerKey ??= (StringBuffer()
        ..write('$MainController')
        ..write('-')
        ..writeRandom())
      .toString();
}
