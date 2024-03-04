import 'dart:math';

extension PipeX<A> on A {
  B pipe<B>(B Function(A a) f) => f(this);
  B? pipeGuarded<B>(B Function(A a) f, {required Function(Object?, StackTrace)? onError}) {
    try {
      return f(this);
    } on Object catch (e, s) {
      if (onError != null) {
        onError(e, s);
      } else {
        rethrow;
      }
    }
    return null;
  }
}

extension VoidLink on Function()? {
  void link(void $) => this?.call();
}

extension HandleErrorX on Function(Object) {}

extension FunX<A, T> on A Function(T) {
  A prepare(Object object) => Function.apply(this, [object]) as A;
}

extension WriteRandomX on StringBuffer {
  void writeRandom() => write(
        String.fromCharCodes(
          List.generate(Random().nextInt(12) + 3, (index) => Random().nextInt(33) + 89),
        ),
      );
}
