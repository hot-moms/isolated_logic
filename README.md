# Isolated Logic

## Install

stable: `dart pub add isolated_logic`

## Features

- Easy: Just wrap your existing controllers into wrapper and it's ready to use
- Solution-agnostic: Supports any state management solution that can emit states
  as `Stream<State>`
- Interopability: Supports `StreamBuilders` and `ValueListenableBuilder`'s
- Low overhead: There's only ~5% loss on speed due de/serialization between
  isolates
- Single-for-all Abstraction: Use a multiple business logic approaches under a
  single `IsolatedController` abstraction

## Usage

Example (wrapper for BLoC):

```dart
class PrimesBlocIsolated extends IsolatedController<PrimesBLoC, AppDependencies, PrimesEvent, int> {
  /// Creation of the target controller can be declared as argument
  /// or passed like a 'super' value;
  PrimesBlocIsolated({required super.createController});

  /// [controllerLifecycle] describes lifecycle of the controller that was instantiated at
  /// separated Isolate
  @override
  ControllerLifecycleHandler<PrimesBLoC> get controllerLifecycle => ControllerLifecycleHandler(
        stateStream: (controller) => controller.stream,
        dispose: (controller) => controller.close(),
      );


  /// This events will be handled in separated isolate
  ///
  /// All emited states by these events will be routed into main isolate
  /// via bus
  void increment() => isolateHandle((controller) => controller.add(const PrimesEvent.increment()));
  void decrement() => isolateHandle((controller) => controller.add(const PrimesEvent.decrement()));
}
```

---

2023, Archie Kitsushimo
