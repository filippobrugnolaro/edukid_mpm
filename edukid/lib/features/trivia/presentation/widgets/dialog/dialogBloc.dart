import 'dart:async';

class DialogBloc {
  final _dialogVisibleController = StreamController<bool>.broadcast();
  Stream<bool> get dialogVisible => _dialogVisibleController.stream;

  void showDialog() {
    _dialogVisibleController.sink.add(true);
  }

  void hideDialog() {
    _dialogVisibleController.sink.add(false);
  }

  void dispose() {
    _dialogVisibleController.close();
  }
}
