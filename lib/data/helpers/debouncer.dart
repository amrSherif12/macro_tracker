import 'dart:async';

class DeBouncer {
  final Duration delay;
  Timer? timer;

  DeBouncer({this.delay = const Duration(milliseconds: 150)});

  void call(void Function() callback) {
    if (timer != null) timer!.cancel();
    timer = Timer(delay, callback);
  }
}
