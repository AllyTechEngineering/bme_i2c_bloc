import 'dart:async';

class DataRepository {
  final StreamController<Map<String, dynamic>> _controller =
      StreamController.broadcast();

  DataRepository();

  Stream<Map<String, dynamic>> get dataStream => _controller.stream;

  void updateData(Map<String, dynamic> updatedData) {
    _controller.add(updatedData);
  }

  void dispose() {
    _controller.close();
  }
}
