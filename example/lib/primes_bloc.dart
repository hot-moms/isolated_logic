import 'dart:isolate';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:isolated_logic/isolated_logic.dart';

class PrimesBLoC extends Bloc<SomeCoolEvent, int> {
  PrimesBLoC() : super(0) {
    on<SomeCoolEvent>(
      (event, emit) async {
        // throw const TlsException('asdasd');
        final x = await getPrimes(Random().nextInt(30000) + 100000).toList();
        emit(x.length);
      },
      transformer: (events, mapper) => events.asyncExpand(mapper),
    );
  }
}

Stream<int> getPrimes(int length) async* {
  getIsolate();
  final totalTimer = Stopwatch()..start();
  final iterationTimer = Stopwatch()..start();
  bool isPrimeTest(int number) => number.isPrime;
  try {
    yield* Stream<int>.fromIterable(() sync* {
      for (var i = 0; i < length; i++) {
        yield i;
      }
    }())
        .asyncMap<int>((i) async {
      if (iterationTimer.elapsedMilliseconds > 8) {
        await Future<void>.delayed(Duration.zero);
        iterationTimer.reset();
      }
      return i;
    }).where(isPrimeTest);
  } finally {
    print('Stopwatch: ${totalTimer.elapsedMilliseconds} ms');
    iterationTimer.stop();
    totalTimer.stop();
  }
}

void getIsolate() {
  print('Isolate: ${Isolate.current.debugName}');
}

extension on int {
  bool get isPrime {
    if (this > 1) {
      for (int i = 2; i < this; i++) {
        if (this % i != 0) continue;
        return false;
      }
      return true;
    } else {
      return false;
    }
  }
}

sealed class SomeCoolEvent {
  const factory SomeCoolEvent.increment() = _Increment$JsonState;
  const factory SomeCoolEvent.decrement() = _Decrement$JsonState;
}

class _Increment$JsonState implements SomeCoolEvent {
  const _Increment$JsonState();
}

class _Decrement$JsonState implements SomeCoolEvent {
  const _Decrement$JsonState();
}

class JsonBlocIsolated extends IsolatedController<PrimesBLoC, Object, SomeCoolEvent, int> {
  JsonBlocIsolated({required super.createController});

  @override
  ControllerLifecycleHandler<PrimesBLoC> get controllerLifecycle => ControllerLifecycleHandler(
        stateStream: (controller) => controller.stream,
        dispose: (controller) => controller.close(),
      );

  void increment() => isolateHandle((controller) => controller.add(const SomeCoolEvent.increment()));
  void decrement() => isolateHandle((controller) => controller.add(const SomeCoolEvent.decrement()));
}
